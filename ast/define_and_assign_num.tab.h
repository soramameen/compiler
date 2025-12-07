/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ASSIGN = 258,
     SEMIC = 259,
     DEFINE = 260,
     NUMBER = 261,
     IDENT = 262,
     EQ = 263,
     NE = 264,
     LE = 265,
     GE = 266,
     LT = 267,
     GT = 268,
     PLUS = 269,
     MINUS = 270,
     MUL = 271,
     DIV = 272,
     L_PAREN = 273,
     R_PAREN = 274,
     L_BRACE = 275,
     R_BRACE = 276,
     L_BRACKET = 277,
     R_BRACKET = 278,
     ARRAY = 279,
     WHILE = 280,
     FOR = 281,
     IF = 282,
     ELSE = 283
   };
#endif
/* Tokens.  */
#define ASSIGN 258
#define SEMIC 259
#define DEFINE 260
#define NUMBER 261
#define IDENT 262
#define EQ 263
#define NE 264
#define LE 265
#define GE 266
#define LT 267
#define GT 268
#define PLUS 269
#define MINUS 270
#define MUL 271
#define DIV 272
#define L_PAREN 273
#define R_PAREN 274
#define L_BRACE 275
#define R_BRACE 276
#define L_BRACKET 277
#define R_BRACKET 278
#define ARRAY 279
#define WHILE 280
#define FOR 281
#define IF 282
#define ELSE 283




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 11 "define_and_assign_num.y"
{
    struct node *np;
    int num;
    char *str;
}
/* Line 1529 of yacc.c.  */
#line 111 "define_and_assign_num.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

