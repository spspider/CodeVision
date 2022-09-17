#ifndef _type_h_
#define _type_h_

typedef unsigned char byte;

typedef struct {
byte Second;
byte Minute;
byte Hour;
}tClock1;

typedef struct {
byte Second;
byte Minute;
byte Hour;
byte Day;
byte DayWeek;
byte Month;
byte Year;
}tClock2;

#endif
