#include <cpctelera.h>
#include <sprite.h>


typedef struct
{
    u8 x, y;
    u8 w, h;
    const u8* sprite;
}TPro;

extern TPro* pro;


#define ProY    1
#define ProW    2
#define ProH    3
#define ProSpr1 4
#define ProSpr2 5


void initPro();

void movePro();

u8* getPro();

u8 getProX();

u8 getProY();

u8 getProW();

u8 getProH();

u8* getProSpr();