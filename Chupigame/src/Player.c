#include "Player.h"

TPro Pro;

TPro* pro = &Pro;

void initPro()
{
    pro = &Pro;

    Pro.x       = 20;
    Pro.y       = 96;
    Pro.w       = P_SPRITE_W;
    Pro.h       = P_SPRITE_H;
    Pro.sprite  = p_sprite;   
}

void movePro()
{
    Pro.x++;
}

u8* getPro()
{
    return &Pro;
}

u8 getProX()
{
    return Pro.x;
}

u8 getProY()
{
    return Pro.y;
}

u8 getProW()
{
    return Pro.w;
}

u8 getProH()
{
    return Pro.h;
}

const u8* getProSpr()
{
    return Pro.sprite;
}