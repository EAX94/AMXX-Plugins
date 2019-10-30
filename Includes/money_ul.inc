#pragma library money_ul

/* Returns users money.
 */
native cs_get_user_money_ul(index);

/* Gives money to user. If flash is 1, the difference between new and old amount will flash red or green.
 */
native cs_set_user_money_ul(index, money, flash = 1);