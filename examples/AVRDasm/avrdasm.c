#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "parser.h"


char sfr[MAXSFR][SFRLEN];

union { char   byte[4];
        short  word[2];
        long   dword;
      } code;


long operand(long code, long mask) {
  char i, j = 0;
  long op = 0;

  for(i = 0; i < sizeof(code) * 8; i++) {

    if(mask & (1l << i)) op |= (code & (1l << i)) >> j;
    else j++;
  }

  return op;
}


long swapd(unsigned long dword) {

  return (dword << 16) | (dword >> 16);
}


short expw(unsigned short word) {
  unsigned short mask = 0x8000;

  while(!(word & mask)) {

    word |= mask;  mask >>= 1;
  }

  return word;
}


char* prepare(unsigned char idx, short op1, short op2) {
  char i;
  char *p1, *p2;
  static char s1[64], s2[64];

  sprintf(s1, cmd[idx].mnemo, op1, op2);

  if((cmd[idx].extra == -1) && (p1 = strchr(s1, SFRPTRN[0]))) {

    memset(s2, 0, sizeof(s2));
    i = strtol(p1 + 1, &p2, 16);

    memcpy(s2, s1, p1 - s1);
    strcpy(s2 + strlen(s2), sfr[i]);
    strcpy(s2 + strlen(s2), p2);

    return s2;
  }

  return s1;
}


char parser(FILE* out, long limit) {
  unsigned char i = 0;
  static long pc = 0;
  short op;
  long swapcode;

  while(1) {

    if((code.word[0] & cmd[i].opcode) == cmd[i].opcode) {

      switch(cmd[i].extra) {
        case 1:     // Constant
          if(code.word[0] != cmd[i].opcode) { i++;  continue; }
          break;

        case 2:     // Zero
          if(operand(code.word[0], cmd[i].op2)) { i++;  continue; }
          break;

        case 3:     // Equality
          if(operand(code.word[0], cmd[i].op1)
             != operand(code.word[0], cmd[i].op2)) { i++;  continue; }
          break;
      }

      fprintf(out, "  %08lX: ", pc);
      pc += abs(cmd[i].length) * CMDLEN;

      switch(cmd[i].length) {
        case 1:
          op = operand(code.word[0], cmd[i].op2);
          if(cmd[i].extra == -2) op = op * cmd[i].scale + cmd[i].base;

          fprintf(out, "%04hX                ", code.word[0]);
          fprintf(out,
                  prepare(i, (short)operand(code.word[0], cmd[i].op1) * cmd[i].scale + cmd[i].base,
                             op));
          fprintf(out, "\n");

          code.word[0] = code.word[1];
          return sizeof(code) - CMDLEN;

        case -1:
          op = operand(code.word[0], cmd[i].op1);
          if(op > operand(cmd[i].op1, cmd[i].op1) / 2) op = expw(op);

          fprintf(out, "%04hX                ", code.word[0]);
          fprintf(out, cmd[i].mnemo, (pc + op * cmd[i].scale) & limit);
          fprintf(out, "\n");

          code.word[0] = code.word[1];
          return sizeof(code) - CMDLEN;

        case 2:
          swapcode = swapd(code.dword);

          fprintf(out, "%08lX            ", swapcode);
          fprintf(out, cmd[i].mnemo,
                  operand(swapcode, cmd[i].op1) * cmd[i].scale,
                  operand(swapcode, cmd[i].op2));
          fprintf(out, "\n");
          return sizeof(code) - CMDLEN * 2;
      }
    }
    i++;
  }
}


void sfrset(char* pattern) {
  char i;

  for(i = 0; i < MAXSFR; i++) sprintf(sfr[i], pattern, i);
}


void terminate(char error, char* str) {

  printf("\nError: ");

  switch(error) {
    case eFILE:
      printf("Can't open");
      break;

    case eKEY:
      printf("Unknown option");
      break;
  }

  printf(" \'%s\'.\7\n\n", str);

  exit(EXIT_FAILURE);
}


void main(int argc, char* argv[]) {
  FILE *def, *in, *out;
  char *param, ln[128] = { 0 };
  long limit = 0xFFFFFFFF;
  char i, j, n = 0;
  short ch;

  if((argc < 2) || strchr(argv[1], '?')) {

HELP_AND_EXIT:
    printf("\nAVRDasm Version 1.05\n"
           "AVR Disassembler by Sot (2kon@mail.ru)\n\n"
           "Usage: avrdasm binfile [lstfile] [/option]\n\n"
           "<binfile> is the binary input file\n"
           "<lstfile> is the listing file to create\n\n"
           "<option>  may be any of the following\n\n"
           "  /Dxxx   Defining file name\n"
           "  /Ln     Program memory limit (hex)\n\n"
           "  /?      This help text\n\n");

    exit(EXIT_SUCCESS);
  }

  sfrset(SFRPTRN);

  for(i = 2; i < argc; i++) {

    if(param = strpbrk(argv[i], "-/")) {

      switch(toupper(param[1])) {
        case 'D':
          if(!(def = fopen(&param[2], "rt"))) terminate(eFILE, &param[2]);

          sfrset(SFRPTRN);

          for(j = 0; j < MAXSFR; j++) {

            if(fscanf(def, "%hX", &ch) == EOF) break;
            if(ch < MAXSFR) fscanf(def, "%s", sfr[ch]);
          }
          break;

        case 'L':
          sscanf(&param[2], "%lX", &limit);
          break;

        case '?':
          goto HELP_AND_EXIT;

        default:
          terminate(eKEY, &param[0]);
      }
    }

    else strcpy(ln, argv[i]);
  }

  if(!ln[0]) {

    strcpy(ln, argv[1]);
    strcpy(strchr(ln, '.'), ".lst");
  }

  if(!(in = fopen(argv[1], "rb"))) terminate(eFILE, argv[1]);
  if(!(out = fopen(ln, "wt"))) terminate(eFILE, ln);

  do {

    for(i = n; i < sizeof(code); i++) {

      if((ch = fgetc(in)) == EOF) break;
      else code.byte[i] = ch;
    }

    if(i >= CMDLEN) n = parser(out, limit);
  }
  while(ch != EOF);

  exit(EXIT_SUCCESS);
}
