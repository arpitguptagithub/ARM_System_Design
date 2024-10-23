/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "prob1.y"

#include<stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex();
int yyerror(char *);
int eflag=0;
extern FILE * yyin;

//  INC "("ID ")" | "("ID ")" INC | DEC "("ID ")" | "("ID ")" DEC | 



char *gen_var();
char *gen_label();
char *gen_out_fun();
char *itoa(int num);
void initialize();

#line 91 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IDENTIFIER = 258,              /* IDENTIFIER  */
    CONSTANT = 259,                /* CONSTANT  */
    STRING_LITERAL = 260,          /* STRING_LITERAL  */
    SIZEOF = 261,                  /* SIZEOF  */
    PTR_OP = 262,                  /* PTR_OP  */
    INC_OP = 263,                  /* INC_OP  */
    DEC_OP = 264,                  /* DEC_OP  */
    LEFT_OP = 265,                 /* LEFT_OP  */
    RIGHT_OP = 266,                /* RIGHT_OP  */
    LE_OP = 267,                   /* LE_OP  */
    GE_OP = 268,                   /* GE_OP  */
    EQ_OP = 269,                   /* EQ_OP  */
    NE_OP = 270,                   /* NE_OP  */
    AND_OP = 271,                  /* AND_OP  */
    OR_OP = 272,                   /* OR_OP  */
    MUL_ASSIGN = 273,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 274,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 275,              /* MOD_ASSIGN  */
    ADD_ASSIGN = 276,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 277,              /* SUB_ASSIGN  */
    LEFT_ASSIGN = 278,             /* LEFT_ASSIGN  */
    RIGHT_ASSIGN = 279,            /* RIGHT_ASSIGN  */
    AND_ASSIGN = 280,              /* AND_ASSIGN  */
    XOR_ASSIGN = 281,              /* XOR_ASSIGN  */
    OR_ASSIGN = 282,               /* OR_ASSIGN  */
    TYPE_NAME = 283,               /* TYPE_NAME  */
    TYPEDEF = 284,                 /* TYPEDEF  */
    EXTERN = 285,                  /* EXTERN  */
    STATIC = 286,                  /* STATIC  */
    AUTO = 287,                    /* AUTO  */
    REGISTER = 288,                /* REGISTER  */
    CHAR = 289,                    /* CHAR  */
    SHORT = 290,                   /* SHORT  */
    INT = 291,                     /* INT  */
    LONG = 292,                    /* LONG  */
    SIGNED = 293,                  /* SIGNED  */
    UNSIGNED = 294,                /* UNSIGNED  */
    FLOAT = 295,                   /* FLOAT  */
    DOUBLE = 296,                  /* DOUBLE  */
    CONST = 297,                   /* CONST  */
    VOLATILE = 298,                /* VOLATILE  */
    VOID = 299,                    /* VOID  */
    STRUCT = 300,                  /* STRUCT  */
    UNION = 301,                   /* UNION  */
    ENUM = 302,                    /* ENUM  */
    ELLIPSIS = 303,                /* ELLIPSIS  */
    CASE = 304,                    /* CASE  */
    DEFAULT = 305,                 /* DEFAULT  */
    IF = 306,                      /* IF  */
    ELSE = 307,                    /* ELSE  */
    SWITCH = 308,                  /* SWITCH  */
    WHILE = 309,                   /* WHILE  */
    DO = 310,                      /* DO  */
    FOR = 311,                     /* FOR  */
    GOTO = 312,                    /* GOTO  */
    CONTINUE = 313,                /* CONTINUE  */
    BREAK = 314,                   /* BREAK  */
    RETURN = 315,                  /* RETURN  */
    CLASS = 316,                   /* CLASS  */
    PRIVATE = 317,                 /* PRIVATE  */
    PUBLIC = 318,                  /* PUBLIC  */
    PROTECTED = 319,               /* PROTECTED  */
    VIRTUAL = 320,                 /* VIRTUAL  */
    NEW = 321,                     /* NEW  */
    DELETE = 322,                  /* DELETE  */
    THIS = 323,                    /* THIS  */
    OPERATOR = 324,                /* OPERATOR  */
    TEMPLATE = 325,                /* TEMPLATE  */
    FRIEND = 326,                  /* FRIEND  */
    NAMESPACE = 327,               /* NAMESPACE  */
    USING = 328,                   /* USING  */
    THROW = 329,                   /* THROW  */
    TRY = 330,                     /* TRY  */
    CATCH = 331                    /* CATCH  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define IDENTIFIER 258
#define CONSTANT 259
#define STRING_LITERAL 260
#define SIZEOF 261
#define PTR_OP 262
#define INC_OP 263
#define DEC_OP 264
#define LEFT_OP 265
#define RIGHT_OP 266
#define LE_OP 267
#define GE_OP 268
#define EQ_OP 269
#define NE_OP 270
#define AND_OP 271
#define OR_OP 272
#define MUL_ASSIGN 273
#define DIV_ASSIGN 274
#define MOD_ASSIGN 275
#define ADD_ASSIGN 276
#define SUB_ASSIGN 277
#define LEFT_ASSIGN 278
#define RIGHT_ASSIGN 279
#define AND_ASSIGN 280
#define XOR_ASSIGN 281
#define OR_ASSIGN 282
#define TYPE_NAME 283
#define TYPEDEF 284
#define EXTERN 285
#define STATIC 286
#define AUTO 287
#define REGISTER 288
#define CHAR 289
#define SHORT 290
#define INT 291
#define LONG 292
#define SIGNED 293
#define UNSIGNED 294
#define FLOAT 295
#define DOUBLE 296
#define CONST 297
#define VOLATILE 298
#define VOID 299
#define STRUCT 300
#define UNION 301
#define ENUM 302
#define ELLIPSIS 303
#define CASE 304
#define DEFAULT 305
#define IF 306
#define ELSE 307
#define SWITCH 308
#define WHILE 309
#define DO 310
#define FOR 311
#define GOTO 312
#define CONTINUE 313
#define BREAK 314
#define RETURN 315
#define CLASS 316
#define PRIVATE 317
#define PUBLIC 318
#define PROTECTED 319
#define VIRTUAL 320
#define NEW 321
#define DELETE 322
#define THIS 323
#define OPERATOR 324
#define TEMPLATE 325
#define FRIEND 326
#define NAMESPACE 327
#define USING 328
#define THROW 329
#define TRY 330
#define CATCH 331

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_IDENTIFIER = 3,                 /* IDENTIFIER  */
  YYSYMBOL_CONSTANT = 4,                   /* CONSTANT  */
  YYSYMBOL_STRING_LITERAL = 5,             /* STRING_LITERAL  */
  YYSYMBOL_SIZEOF = 6,                     /* SIZEOF  */
  YYSYMBOL_PTR_OP = 7,                     /* PTR_OP  */
  YYSYMBOL_INC_OP = 8,                     /* INC_OP  */
  YYSYMBOL_DEC_OP = 9,                     /* DEC_OP  */
  YYSYMBOL_LEFT_OP = 10,                   /* LEFT_OP  */
  YYSYMBOL_RIGHT_OP = 11,                  /* RIGHT_OP  */
  YYSYMBOL_LE_OP = 12,                     /* LE_OP  */
  YYSYMBOL_GE_OP = 13,                     /* GE_OP  */
  YYSYMBOL_EQ_OP = 14,                     /* EQ_OP  */
  YYSYMBOL_NE_OP = 15,                     /* NE_OP  */
  YYSYMBOL_AND_OP = 16,                    /* AND_OP  */
  YYSYMBOL_OR_OP = 17,                     /* OR_OP  */
  YYSYMBOL_MUL_ASSIGN = 18,                /* MUL_ASSIGN  */
  YYSYMBOL_DIV_ASSIGN = 19,                /* DIV_ASSIGN  */
  YYSYMBOL_MOD_ASSIGN = 20,                /* MOD_ASSIGN  */
  YYSYMBOL_ADD_ASSIGN = 21,                /* ADD_ASSIGN  */
  YYSYMBOL_SUB_ASSIGN = 22,                /* SUB_ASSIGN  */
  YYSYMBOL_LEFT_ASSIGN = 23,               /* LEFT_ASSIGN  */
  YYSYMBOL_RIGHT_ASSIGN = 24,              /* RIGHT_ASSIGN  */
  YYSYMBOL_AND_ASSIGN = 25,                /* AND_ASSIGN  */
  YYSYMBOL_XOR_ASSIGN = 26,                /* XOR_ASSIGN  */
  YYSYMBOL_OR_ASSIGN = 27,                 /* OR_ASSIGN  */
  YYSYMBOL_TYPE_NAME = 28,                 /* TYPE_NAME  */
  YYSYMBOL_TYPEDEF = 29,                   /* TYPEDEF  */
  YYSYMBOL_EXTERN = 30,                    /* EXTERN  */
  YYSYMBOL_STATIC = 31,                    /* STATIC  */
  YYSYMBOL_AUTO = 32,                      /* AUTO  */
  YYSYMBOL_REGISTER = 33,                  /* REGISTER  */
  YYSYMBOL_CHAR = 34,                      /* CHAR  */
  YYSYMBOL_SHORT = 35,                     /* SHORT  */
  YYSYMBOL_INT = 36,                       /* INT  */
  YYSYMBOL_LONG = 37,                      /* LONG  */
  YYSYMBOL_SIGNED = 38,                    /* SIGNED  */
  YYSYMBOL_UNSIGNED = 39,                  /* UNSIGNED  */
  YYSYMBOL_FLOAT = 40,                     /* FLOAT  */
  YYSYMBOL_DOUBLE = 41,                    /* DOUBLE  */
  YYSYMBOL_CONST = 42,                     /* CONST  */
  YYSYMBOL_VOLATILE = 43,                  /* VOLATILE  */
  YYSYMBOL_VOID = 44,                      /* VOID  */
  YYSYMBOL_STRUCT = 45,                    /* STRUCT  */
  YYSYMBOL_UNION = 46,                     /* UNION  */
  YYSYMBOL_ENUM = 47,                      /* ENUM  */
  YYSYMBOL_ELLIPSIS = 48,                  /* ELLIPSIS  */
  YYSYMBOL_CASE = 49,                      /* CASE  */
  YYSYMBOL_DEFAULT = 50,                   /* DEFAULT  */
  YYSYMBOL_IF = 51,                        /* IF  */
  YYSYMBOL_ELSE = 52,                      /* ELSE  */
  YYSYMBOL_SWITCH = 53,                    /* SWITCH  */
  YYSYMBOL_WHILE = 54,                     /* WHILE  */
  YYSYMBOL_DO = 55,                        /* DO  */
  YYSYMBOL_FOR = 56,                       /* FOR  */
  YYSYMBOL_GOTO = 57,                      /* GOTO  */
  YYSYMBOL_CONTINUE = 58,                  /* CONTINUE  */
  YYSYMBOL_BREAK = 59,                     /* BREAK  */
  YYSYMBOL_RETURN = 60,                    /* RETURN  */
  YYSYMBOL_CLASS = 61,                     /* CLASS  */
  YYSYMBOL_PRIVATE = 62,                   /* PRIVATE  */
  YYSYMBOL_PUBLIC = 63,                    /* PUBLIC  */
  YYSYMBOL_PROTECTED = 64,                 /* PROTECTED  */
  YYSYMBOL_VIRTUAL = 65,                   /* VIRTUAL  */
  YYSYMBOL_NEW = 66,                       /* NEW  */
  YYSYMBOL_DELETE = 67,                    /* DELETE  */
  YYSYMBOL_THIS = 68,                      /* THIS  */
  YYSYMBOL_OPERATOR = 69,                  /* OPERATOR  */
  YYSYMBOL_TEMPLATE = 70,                  /* TEMPLATE  */
  YYSYMBOL_FRIEND = 71,                    /* FRIEND  */
  YYSYMBOL_NAMESPACE = 72,                 /* NAMESPACE  */
  YYSYMBOL_USING = 73,                     /* USING  */
  YYSYMBOL_THROW = 74,                     /* THROW  */
  YYSYMBOL_TRY = 75,                       /* TRY  */
  YYSYMBOL_CATCH = 76,                     /* CATCH  */
  YYSYMBOL_77_ = 77,                       /* ','  */
  YYSYMBOL_78_ = 78,                       /* '{'  */
  YYSYMBOL_79_ = 79,                       /* '}'  */
  YYSYMBOL_80_ = 80,                       /* ':'  */
  YYSYMBOL_81_ = 81,                       /* '('  */
  YYSYMBOL_82_ = 82,                       /* ')'  */
  YYSYMBOL_83_ = 83,                       /* '~'  */
  YYSYMBOL_84_ = 84,                       /* '['  */
  YYSYMBOL_85_ = 85,                       /* ']'  */
  YYSYMBOL_86_ = 86,                       /* ';'  */
  YYSYMBOL_87_ = 87,                       /* '.'  */
  YYSYMBOL_88_ = 88,                       /* '&'  */
  YYSYMBOL_89_ = 89,                       /* '*'  */
  YYSYMBOL_90_ = 90,                       /* '+'  */
  YYSYMBOL_91_ = 91,                       /* '-'  */
  YYSYMBOL_92_ = 92,                       /* '!'  */
  YYSYMBOL_93_ = 93,                       /* '/'  */
  YYSYMBOL_94_ = 94,                       /* '%'  */
  YYSYMBOL_95_ = 95,                       /* '<'  */
  YYSYMBOL_96_ = 96,                       /* '>'  */
  YYSYMBOL_97_ = 97,                       /* '^'  */
  YYSYMBOL_98_ = 98,                       /* '|'  */
  YYSYMBOL_99_ = 99,                       /* '?'  */
  YYSYMBOL_100_ = 100,                     /* '='  */
  YYSYMBOL_YYACCEPT = 101,                 /* $accept  */
  YYSYMBOL_expression_list = 102,          /* expression_list  */
  YYSYMBOL_class_specifier = 103,          /* class_specifier  */
  YYSYMBOL_base_specifier_list = 104,      /* base_specifier_list  */
  YYSYMBOL_base_specifier = 105,           /* base_specifier  */
  YYSYMBOL_class_body = 106,               /* class_body  */
  YYSYMBOL_class_member_declaration = 107, /* class_member_declaration  */
  YYSYMBOL_access_specifier = 108,         /* access_specifier  */
  YYSYMBOL_member_declaration = 109,       /* member_declaration  */
  YYSYMBOL_member_function_definition = 110, /* member_function_definition  */
  YYSYMBOL_constructor_definition = 111,   /* constructor_definition  */
  YYSYMBOL_constructor_initializer = 112,  /* constructor_initializer  */
  YYSYMBOL_member_initializer_list = 113,  /* member_initializer_list  */
  YYSYMBOL_member_initializer = 114,       /* member_initializer  */
  YYSYMBOL_destructor_definition = 115,    /* destructor_definition  */
  YYSYMBOL_declaration_specifiers = 116,   /* declaration_specifiers  */
  YYSYMBOL_type_specifier = 117,           /* type_specifier  */
  YYSYMBOL_new_expression = 118,           /* new_expression  */
  YYSYMBOL_delete_expression = 119,        /* delete_expression  */
  YYSYMBOL_primary_expression = 120,       /* primary_expression  */
  YYSYMBOL_namespace_definition = 121,     /* namespace_definition  */
  YYSYMBOL_using_directive = 122,          /* using_directive  */
  YYSYMBOL_external_declaration = 123,     /* external_declaration  */
  YYSYMBOL_postfix_expression = 124,       /* postfix_expression  */
  YYSYMBOL_argument_expression_list = 125, /* argument_expression_list  */
  YYSYMBOL_unary_expression = 126,         /* unary_expression  */
  YYSYMBOL_unary_operator = 127,           /* unary_operator  */
  YYSYMBOL_cast_expression = 128,          /* cast_expression  */
  YYSYMBOL_multiplicative_expression = 129, /* multiplicative_expression  */
  YYSYMBOL_additive_expression = 130,      /* additive_expression  */
  YYSYMBOL_shift_expression = 131,         /* shift_expression  */
  YYSYMBOL_relational_expression = 132,    /* relational_expression  */
  YYSYMBOL_equality_expression = 133,      /* equality_expression  */
  YYSYMBOL_and_expression = 134,           /* and_expression  */
  YYSYMBOL_exclusive_or_expression = 135,  /* exclusive_or_expression  */
  YYSYMBOL_inclusive_or_expression = 136,  /* inclusive_or_expression  */
  YYSYMBOL_logical_and_expression = 137,   /* logical_and_expression  */
  YYSYMBOL_logical_or_expression = 138,    /* logical_or_expression  */
  YYSYMBOL_conditional_expression = 139,   /* conditional_expression  */
  YYSYMBOL_assignment_expression = 140,    /* assignment_expression  */
  YYSYMBOL_assignment_operator = 141,      /* assignment_operator  */
  YYSYMBOL_expression = 142,               /* expression  */
  YYSYMBOL_constant_expression = 143,      /* constant_expression  */
  YYSYMBOL_declaration = 144,              /* declaration  */
  YYSYMBOL_init_declarator_list = 145,     /* init_declarator_list  */
  YYSYMBOL_init_declarator = 146,          /* init_declarator  */
  YYSYMBOL_storage_class_specifier = 147,  /* storage_class_specifier  */
  YYSYMBOL_struct_or_union_specifier = 148, /* struct_or_union_specifier  */
  YYSYMBOL_struct_or_union = 149,          /* struct_or_union  */
  YYSYMBOL_struct_declaration_list = 150,  /* struct_declaration_list  */
  YYSYMBOL_struct_declaration = 151,       /* struct_declaration  */
  YYSYMBOL_specifier_qualifier_list = 152, /* specifier_qualifier_list  */
  YYSYMBOL_struct_declarator_list = 153,   /* struct_declarator_list  */
  YYSYMBOL_struct_declarator = 154,        /* struct_declarator  */
  YYSYMBOL_enum_specifier = 155,           /* enum_specifier  */
  YYSYMBOL_enumerator_list = 156,          /* enumerator_list  */
  YYSYMBOL_enumerator = 157,               /* enumerator  */
  YYSYMBOL_type_qualifier = 158,           /* type_qualifier  */
  YYSYMBOL_declarator = 159,               /* declarator  */
  YYSYMBOL_direct_declarator = 160,        /* direct_declarator  */
  YYSYMBOL_pointer = 161,                  /* pointer  */
  YYSYMBOL_type_qualifier_list = 162,      /* type_qualifier_list  */
  YYSYMBOL_parameter_type_list = 163,      /* parameter_type_list  */
  YYSYMBOL_parameter_list = 164,           /* parameter_list  */
  YYSYMBOL_parameter_declaration = 165,    /* parameter_declaration  */
  YYSYMBOL_identifier_list = 166,          /* identifier_list  */
  YYSYMBOL_type_name = 167,                /* type_name  */
  YYSYMBOL_abstract_declarator = 168,      /* abstract_declarator  */
  YYSYMBOL_direct_abstract_declarator = 169, /* direct_abstract_declarator  */
  YYSYMBOL_initializer = 170,              /* initializer  */
  YYSYMBOL_initializer_list = 171,         /* initializer_list  */
  YYSYMBOL_statement = 172,                /* statement  */
  YYSYMBOL_labeled_statement = 173,        /* labeled_statement  */
  YYSYMBOL_compound_statement = 174,       /* compound_statement  */
  YYSYMBOL_declaration_list = 175,         /* declaration_list  */
  YYSYMBOL_statement_list = 176,           /* statement_list  */
  YYSYMBOL_expression_statement = 177,     /* expression_statement  */
  YYSYMBOL_selection_statement = 178,      /* selection_statement  */
  YYSYMBOL_iteration_statement = 179,      /* iteration_statement  */
  YYSYMBOL_jump_statement = 180,           /* jump_statement  */
  YYSYMBOL_translation_unit = 181,         /* translation_unit  */
  YYSYMBOL_function_definition = 182       /* function_definition  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  60
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1862

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  101
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  82
/* YYNRULES -- Number of rules.  */
#define YYNRULES  258
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  446

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   331


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    92,     2,     2,     2,    94,    88,     2,
      81,    82,    89,    90,    77,    91,    87,    93,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    80,    86,
      95,   100,    96,    99,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    84,     2,    85,    97,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    78,    98,    79,    83,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    43,    43,    44,    48,    49,    50,    51,    55,    56,
      60,    61,    62,    63,    67,    68,    72,    73,    77,    78,
      79,    83,    84,    85,    86,    90,    94,    95,    99,   100,
     104,   105,   109,   110,   114,   119,   120,   121,   122,   123,
     124,   125,   126,   131,   132,   133,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   151,   152,   153,   156,   157,
     162,   163,   164,   165,   166,   171,   172,   176,   181,   182,
     183,   184,   202,   203,   204,   205,   206,   207,   208,   209,
     210,   211,   215,   216,   220,   221,   222,   223,   224,   225,
     226,   227,   231,   231,   231,   231,   231,   231,   235,   236,
     240,   241,   242,   243,   247,   248,   249,   253,   254,   255,
     259,   260,   261,   262,   263,   267,   268,   269,   273,   274,
     278,   279,   283,   284,   288,   289,   293,   294,   298,   299,
     303,   304,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   322,   323,   327,   331,   332,   336,   337,
     341,   342,   346,   347,   348,   349,   350,   355,   356,   357,
     361,   362,   366,   367,   371,   375,   376,   377,   378,   382,
     383,   387,   388,   389,   393,   394,   395,   399,   400,   404,
     405,   409,   410,   414,   415,   419,   420,   421,   422,   423,
     424,   425,   429,   430,   431,   432,   436,   437,   442,   443,
     447,   448,   452,   454,   458,   459,   463,   464,   468,   469,
     470,   474,   475,   476,   477,   478,   479,   480,   481,   482,
     486,   487,   488,   492,   493,   497,   498,   499,   500,   501,
     502,   506,   507,   508,   512,   513,   514,   515,   519,   520,
     524,   525,   529,   530,   534,   535,   536,   540,   541,   542,
     543,   547,   548,   549,   550,   551,   555,   556,   564
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "IDENTIFIER",
  "CONSTANT", "STRING_LITERAL", "SIZEOF", "PTR_OP", "INC_OP", "DEC_OP",
  "LEFT_OP", "RIGHT_OP", "LE_OP", "GE_OP", "EQ_OP", "NE_OP", "AND_OP",
  "OR_OP", "MUL_ASSIGN", "DIV_ASSIGN", "MOD_ASSIGN", "ADD_ASSIGN",
  "SUB_ASSIGN", "LEFT_ASSIGN", "RIGHT_ASSIGN", "AND_ASSIGN", "XOR_ASSIGN",
  "OR_ASSIGN", "TYPE_NAME", "TYPEDEF", "EXTERN", "STATIC", "AUTO",
  "REGISTER", "CHAR", "SHORT", "INT", "LONG", "SIGNED", "UNSIGNED",
  "FLOAT", "DOUBLE", "CONST", "VOLATILE", "VOID", "STRUCT", "UNION",
  "ENUM", "ELLIPSIS", "CASE", "DEFAULT", "IF", "ELSE", "SWITCH", "WHILE",
  "DO", "FOR", "GOTO", "CONTINUE", "BREAK", "RETURN", "CLASS", "PRIVATE",
  "PUBLIC", "PROTECTED", "VIRTUAL", "NEW", "DELETE", "THIS", "OPERATOR",
  "TEMPLATE", "FRIEND", "NAMESPACE", "USING", "THROW", "TRY", "CATCH",
  "','", "'{'", "'}'", "':'", "'('", "')'", "'~'", "'['", "']'", "';'",
  "'.'", "'&'", "'*'", "'+'", "'-'", "'!'", "'/'", "'%'", "'<'", "'>'",
  "'^'", "'|'", "'?'", "'='", "$accept", "expression_list",
  "class_specifier", "base_specifier_list", "base_specifier", "class_body",
  "class_member_declaration", "access_specifier", "member_declaration",
  "member_function_definition", "constructor_definition",
  "constructor_initializer", "member_initializer_list",
  "member_initializer", "destructor_definition", "declaration_specifiers",
  "type_specifier", "new_expression", "delete_expression",
  "primary_expression", "namespace_definition", "using_directive",
  "external_declaration", "postfix_expression", "argument_expression_list",
  "unary_expression", "unary_operator", "cast_expression",
  "multiplicative_expression", "additive_expression", "shift_expression",
  "relational_expression", "equality_expression", "and_expression",
  "exclusive_or_expression", "inclusive_or_expression",
  "logical_and_expression", "logical_or_expression",
  "conditional_expression", "assignment_expression", "assignment_operator",
  "expression", "constant_expression", "declaration",
  "init_declarator_list", "init_declarator", "storage_class_specifier",
  "struct_or_union_specifier", "struct_or_union",
  "struct_declaration_list", "struct_declaration",
  "specifier_qualifier_list", "struct_declarator_list",
  "struct_declarator", "enum_specifier", "enumerator_list", "enumerator",
  "type_qualifier", "declarator", "direct_declarator", "pointer",
  "type_qualifier_list", "parameter_type_list", "parameter_list",
  "parameter_declaration", "identifier_list", "type_name",
  "abstract_declarator", "direct_abstract_declarator", "initializer",
  "initializer_list", "statement", "labeled_statement",
  "compound_statement", "declaration_list", "statement_list",
  "expression_statement", "selection_statement", "iteration_statement",
  "jump_statement", "translation_unit", "function_definition", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-312)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    1721,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,
    -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,
      26,    43,    56,   -52,  1801,    20,  1801,  -312,  -312,  -312,
    -312,  1801,  -312,    65,  -312,  1801,  1441,  -312,   -39,    72,
     177,  1330,     8,  1721,   102,  -312,  -312,    22,  -312,   -11,
     -53,  -312,    19,    91,    12,  -312,  -312,    64,  1362,  -312,
    -312,  -312,    72,   -10,   184,  -312,  1330,   105,    45,  -312,
    -312,  -312,   170,  1162,  -312,    75,  -312,  -312,  -312,  -312,
      20,  -312,  1721,  1617,    97,   111,  -312,  -312,   -11,    22,
    -312,   349,   751,  -312,  1386,   778,    91,  1362,  1362,   593,
    -312,    35,  1362,   196,  1042,    72,  -312,  1218,  -312,   218,
     148,  -312,   246,  1549,   197,  -312,  -312,  -312,    19,  1669,
    -312,  -312,  -312,  -312,  -312,  -312,   183,   220,  -312,  -312,
    1069,  1096,  1096,  1042,   224,   233,   238,   239,   658,   241,
     320,   242,   243,   790,  1362,   817,  -312,  -312,   481,  -312,
    -312,  -312,  -312,  -312,  -312,  -312,    20,  -312,  -312,  -312,
     143,   322,  1042,  -312,    71,   175,   276,    41,   280,   236,
     228,   229,   315,    11,  -312,  -312,   -17,  -312,  -312,  -312,
    -312,   415,   526,  -312,  -312,  -312,  -312,  -312,   751,  -312,
    -312,  -312,  -312,    22,   250,   256,  -312,     3,  -312,  -312,
    -312,   252,  1414,  -312,  -312,  -312,  1042,    10,  -312,   255,
    -312,  -312,  -312,  -312,  -312,  -312,   335,   105,  1330,  -312,
     259,    48,   274,  -312,  -312,   658,   481,  -312,   481,  -312,
    -312,   279,   658,  1042,  1042,  1042,   306,   844,   275,  -312,
    -312,  -312,    54,    98,   138,   277,   286,    67,   282,   362,
    -312,  -312,   883,  1042,   363,  -312,  -312,  -312,  -312,  -312,
    -312,  -312,  -312,  -312,  -312,  -312,  1042,  -312,  1042,  1042,
    1042,  1042,  1042,  1042,  1042,  1042,  1042,  1042,  1042,  1042,
    1042,  1042,  1042,  1042,  1042,  1042,  1042,  1042,  -312,  -312,
    -312,   592,  -312,  -312,  -312,   213,  -312,  -312,  1767,   364,
    -312,  -312,  -312,  -312,    35,  -312,  1042,  -312,  -312,  1274,
     365,   292,  1801,   259,   292,  -312,   289,   290,   658,  -312,
      76,    94,   114,   293,   844,  -312,  -312,  1487,   910,   156,
    -312,   167,  1042,  1042,  1042,  -312,   937,  -312,  -312,   115,
    -312,   -40,  -312,  -312,  -312,  -312,  -312,    71,    71,   175,
     175,   276,   276,   276,   276,    41,    41,   280,   236,   228,
     229,   315,   182,  -312,  -312,   685,  -312,  -312,  -312,  -312,
    -312,  -312,  -312,   294,   296,  -312,  -312,   292,  -312,   298,
     298,  -312,   658,   658,   658,  1042,   976,  -312,   319,   329,
    -312,   312,   167,  1583,  1003,   151,  -312,     7,   286,   751,
    -312,  1042,  -312,  -312,  1042,  -312,  -312,  1030,   365,  -312,
     360,  -312,  -312,   152,   658,   159,  -312,  -312,  -312,  -312,
     331,  -312,   340,  1042,  -312,  -312,   214,  -312,  -312,  -312,
     162,  -312,   658,   328,  -312,   658,  -312,  -312,  -312,   724,
    -312,  -312,  -312,  -312,  -312,  -312
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
       0,    54,   152,   153,   154,   155,   156,    44,    45,    46,
      47,    50,    51,    48,    49,   181,   182,    43,   160,   161,
       0,     0,     0,     0,    41,     0,    37,    70,    71,   256,
      69,    35,    52,     0,    53,    39,     0,    68,   176,     0,
       6,     0,     0,     0,     0,    42,   185,     0,   146,   192,
       0,   148,   150,   184,     0,    38,    36,   159,     0,    40,
       1,   257,     0,   179,     0,   177,     0,     0,     0,    18,
      20,    19,     0,     0,    14,     0,    17,    22,    23,    24,
       0,    21,     0,     0,     0,     0,   196,   194,   193,     0,
     147,     0,     0,   258,     0,     0,   183,     0,   166,     0,
     162,     0,   168,     0,     0,     0,   174,     0,    10,     0,
       0,     8,     0,     0,     0,     7,    15,    16,   150,     0,
      66,    67,   186,   197,   195,   149,   150,    60,    61,    62,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    64,   234,     0,    96,
     242,    92,    93,    94,    95,    97,     0,    90,    91,    72,
      84,    98,     0,   100,   104,   107,   110,   115,   118,   120,
     122,   124,   126,   128,   130,   143,     0,   238,   240,   225,
     226,     0,     0,   227,   228,   229,   230,    60,     0,   220,
     151,   204,   191,   203,     0,   198,   200,     0,   188,    98,
     145,     0,     0,   165,   158,   163,     0,     0,   169,   171,
     167,   175,   180,   178,     4,    11,     0,     0,     0,    12,
      29,     0,     0,    25,    65,     0,     0,    88,     0,    85,
      86,     0,     0,     0,     0,     0,     0,     0,     0,   252,
     253,   254,     0,   206,    55,     0,    58,     0,     0,     0,
      78,    79,     0,     0,     0,   133,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   132,     0,    87,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   243,   236,
     239,     0,   235,   241,   223,     0,   202,   189,     0,     0,
     190,   187,   157,   172,     0,   164,     0,    13,     9,     0,
       0,     0,     0,    29,     0,   231,     0,     0,     0,   233,
       0,     0,     0,     0,     0,   251,   255,     0,     0,   208,
     207,   209,     0,     0,     0,    63,     0,    77,    74,     0,
      82,     0,    76,   131,   101,   102,   103,   105,   106,   108,
     109,   113,   114,   111,   112,   116,   117,   119,   121,   123,
     125,   127,     0,   144,   237,     0,   221,   199,   201,   205,
     170,   173,     5,     0,    28,    30,    27,     0,    34,    89,
       0,   232,     0,     0,     0,     0,     0,   216,     0,     0,
     212,     0,   210,     0,     0,     0,     2,     0,    59,     0,
      99,     0,    75,    73,     0,   222,   224,     0,     0,    26,
     244,   246,   247,     0,     0,     0,   217,   211,   213,   218,
       0,   214,     0,     0,    56,    57,     0,    83,   129,    33,
       0,    31,     0,     0,   249,     0,   219,   215,     3,     0,
      80,    32,   245,   248,   250,    81
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -312,    24,  -312,  -312,   209,   -56,   -59,   -58,  -312,  -312,
    -312,   116,  -312,    28,  -312,   -24,    87,  -312,  -312,  -312,
    -312,  -312,    -2,  -312,  -312,   -68,  -312,  -156,    25,    33,
      -6,    37,   153,   160,   150,   179,   192,  -312,   -83,   -89,
    -312,   -87,   -86,     0,  -312,   378,  -312,  -312,  -312,   381,
     -80,   -72,  -312,   176,  -312,   417,   383,    30,    -3,   437,
     -48,  -312,  -311,   379,  -255,  -312,   -93,   168,   171,   -88,
     100,  -130,  -312,   -47,  -312,   316,  -224,  -312,  -312,  -312,
      -8,  -312
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,   395,    24,   110,   111,    73,    74,    75,    76,    77,
      78,   311,   374,   375,    79,    25,    26,   157,   158,   159,
      27,    28,    29,   160,   339,   161,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   175,
     266,   176,   201,    30,    50,    51,    31,    32,    33,    99,
     100,   101,   207,   208,    34,    64,    65,    35,   126,    53,
      54,    88,   194,   195,   196,   197,   244,   330,   331,   294,
     295,   178,   179,   180,   181,   182,   183,   184,   185,   186,
      36,    37
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      45,    87,    55,   189,   190,    93,   267,    56,   236,   112,
     107,    59,   200,   324,   116,    46,   388,    80,   212,   205,
      44,   200,    52,    46,    89,    46,   203,   199,   285,    38,
     210,    15,    16,    90,    61,    83,   199,   287,    46,    62,
     124,    81,    80,   368,    85,   403,    40,   231,   116,    80,
     200,   216,   293,   275,   276,   248,   242,   368,   246,    42,
     287,   247,   227,   229,   230,   199,    81,   156,    57,   288,
     193,   223,   243,    81,   119,    63,   243,   118,    49,    86,
     299,    61,   420,    80,   287,   300,    82,   304,   102,   193,
     104,   177,   425,    47,   199,   315,   305,    91,   209,   189,
     386,    47,   319,    47,    39,    84,    48,    81,   108,    49,
     286,    49,   344,   345,   346,   206,    47,    61,   123,    92,
     303,    41,   205,   200,    49,   312,   113,   102,   102,   102,
     313,   287,   102,   316,    43,   317,   277,   278,   199,   247,
     326,   247,    97,    58,   287,    98,   320,   321,   322,   335,
     249,   250,   251,   287,   243,   117,   243,   156,   382,   112,
     268,   293,   309,   340,   269,   270,   341,    69,    70,    71,
     109,   287,    94,   114,   102,    95,   383,   343,   102,   327,
     400,   290,   328,   121,    98,    98,    98,    49,   381,    98,
     296,   287,   401,   122,    80,   329,   384,   402,   363,   362,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,    81,   332,
     371,   215,   333,   200,   252,   217,   218,   253,   423,   287,
     254,    98,   102,   424,   433,    98,   287,   327,   199,   423,
     328,   435,   391,   396,   441,   200,   397,   398,   393,   219,
     116,   394,   410,   411,   412,    66,   102,    67,   102,   287,
     199,   105,   404,   106,   376,   271,   272,   378,   199,   351,
     352,   353,   354,   105,   193,   211,   189,   406,   222,   329,
      69,    70,    71,    92,   434,    80,   273,   274,   193,    98,
     365,   439,   366,   440,   279,   280,   347,   348,   413,   415,
     225,   209,   442,   193,   232,   444,   349,   350,   422,    81,
     189,   200,   427,    98,   233,    98,   355,   356,   396,   234,
     235,   428,   237,   238,   281,   282,   199,   283,   239,   240,
     409,   284,   297,   298,   438,   306,   199,   301,   307,   310,
     255,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     189,   406,   127,   128,   129,   130,   314,   131,   132,   318,
     323,   325,   334,   287,   336,   337,   342,   369,   373,   193,
      91,   379,   380,   408,   385,   407,   399,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,   418,   133,   134,
     135,   416,   136,   137,   138,   139,   140,   141,   142,   143,
      21,   417,   432,   436,   443,   144,   145,   146,   127,   128,
     129,   130,   265,   131,   132,   437,   308,    91,   147,   377,
     148,   430,   149,   359,   357,   150,   431,   151,   152,   153,
     154,   155,   358,     1,     2,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,   360,   133,   134,   135,   125,   136,   137,
     138,   139,   140,   141,   142,   143,    21,   361,   202,   103,
     370,   144,   145,   146,   187,   128,   129,   130,   213,   131,
     132,    96,   221,    91,   289,   389,   148,   291,   149,   426,
     392,   150,     0,   151,   152,   153,   154,   155,     0,     1,
       0,     0,     0,     0,     0,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,   127,
     128,   129,   130,     0,   131,   132,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   144,   145,   146,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   148,     0,   149,     0,     0,     0,     0,   151,
     152,   153,   154,   155,     0,   133,   134,   135,     0,   136,
     137,   138,   139,   140,   141,   142,   143,     0,     0,     0,
       0,     0,   144,   145,   146,   127,   128,   129,   130,     0,
     131,   132,     0,     0,    91,   292,     0,   148,     0,   149,
       0,     0,   150,     0,   151,   152,   153,   154,   155,     0,
       0,     1,     0,     0,     0,     0,     0,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,   133,   134,   135,     0,   136,   137,   138,   139,   140,
     141,   142,   143,     0,     0,     0,     0,     0,   144,   145,
     146,   127,   128,   129,   130,     0,   131,   132,     0,     0,
      91,   364,   204,   148,     0,   149,     0,     0,   150,     0,
     151,   152,   153,   154,   155,     0,     0,     0,   187,   128,
     129,   130,     0,   131,   132,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   133,   134,   135,
       0,   136,   137,   138,   139,   140,   141,   142,   143,     0,
       0,     0,     0,     0,   144,   145,   146,   187,   128,   129,
     130,     0,   131,   132,     0,     0,    91,     0,     0,   148,
       0,   149,     0,     0,   150,     0,   151,   152,   153,   154,
     155,   144,   145,   146,   187,   128,   129,   130,     0,   131,
     132,     0,     0,   188,   405,     0,   148,     0,   149,     0,
       0,     0,     0,   151,   152,   153,   154,   155,     0,     0,
       0,   187,   128,   129,   130,     0,   131,   132,     0,     0,
     144,   145,   146,   187,   128,   129,   130,     0,   131,   132,
       0,     0,   188,   445,     0,   148,     0,   149,     0,     0,
       0,     0,   151,   152,   153,   154,   155,   144,   145,   146,
     187,   128,   129,   130,     0,   131,   132,     0,     0,   188,
       0,     0,   148,     0,   149,     0,     0,     0,     0,   151,
     152,   153,   154,   155,   144,   145,   146,   187,   128,   129,
     130,     0,   131,   132,     0,     0,   144,   145,   146,   148,
       0,   149,     0,   198,     0,     0,   151,   152,   153,   154,
     155,   148,     0,   149,     0,     0,   241,     0,   151,   152,
     153,   154,   155,   144,   145,   146,   187,   128,   129,   130,
       0,   131,   132,     0,     0,     0,     0,     0,   148,     0,
     149,   245,     0,     0,     0,   151,   152,   153,   154,   155,
     144,   145,   146,   187,   128,   129,   130,     0,   131,   132,
       0,     0,     0,     0,     0,   148,     0,   149,     0,     0,
     150,     0,   151,   152,   153,   154,   155,     0,     0,     0,
     187,   128,   129,   130,     0,   131,   132,     0,     0,   144,
     145,   146,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   148,   338,   149,     0,     0,     0,
       0,   151,   152,   153,   154,   155,   144,   145,   146,   187,
     128,   129,   130,     0,   131,   132,     0,     0,     0,     0,
       0,   148,     0,   149,     0,   390,     0,     0,   151,   152,
     153,   154,   155,   144,   145,   146,   187,   128,   129,   130,
       0,   131,   132,     0,     0,   399,     0,     0,   148,     0,
     149,     0,     0,     0,     0,   151,   152,   153,   154,   155,
       0,     0,     0,   187,   128,   129,   130,     0,   131,   132,
       0,     0,   144,   145,   146,   187,   128,   129,   130,     0,
     131,   132,     0,     0,     0,     0,     0,   148,   414,   149,
       0,     0,     0,     0,   151,   152,   153,   154,   155,   144,
     145,   146,   187,   128,   129,   130,     0,   131,   132,     0,
       0,     0,     0,     0,   148,     0,   149,     0,   421,     0,
       0,   151,   152,   153,   154,   155,   144,   145,   146,   187,
     128,   129,   130,     0,   131,   132,     0,     0,   144,   145,
     146,   148,   429,   149,     0,     0,     0,     0,   151,   152,
     153,   154,   155,   148,     0,   149,     0,     0,     0,     0,
     151,   152,   153,   154,   155,   144,   145,   146,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     226,     0,   149,     0,     0,     0,     0,   151,   152,   153,
     154,   155,   144,   145,   146,    68,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   228,     0,   149,
       0,     0,     0,     0,   151,   152,   153,   154,   155,     0,
       1,     2,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    68,     0,    21,    69,    70,    71,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   115,     0,     0,     0,    72,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    68,     0,    21,
      69,    70,    71,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   214,     0,     0,
       0,    72,     1,     2,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    68,     0,    21,    69,    70,    71,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   372,     0,     0,     0,    72,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   191,
       1,    21,    69,    70,    71,     0,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
       0,     0,     0,    72,     1,     2,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,     0,     0,     0,     0,     0,     0,
       0,    60,     1,     0,     0,     0,     0,    21,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,     0,     0,     0,     0,     0,   192,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     0,
       0,     0,     0,   302,     0,     0,     0,     0,     0,     0,
       0,     0,    21,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    22,    23,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   327,   387,
       0,   328,     0,     0,     0,     0,    49,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      21,     1,     2,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,   220,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    21,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,   419,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    22,
      23,     0,     0,     0,     0,     0,   120,     1,     2,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,    20,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      21,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,    23,     0,     0,     0,     0,     0,   224,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    21,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    22,    23,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,   367,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     1,
       2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    21
};

static const yytype_int16 yycheck[] =
{
      24,    49,    26,    92,    92,    52,   162,    31,   138,    67,
      66,    35,    95,   237,    73,     3,   327,    41,   104,    99,
      72,   104,    25,     3,    77,     3,    98,    95,    17,     3,
     102,    42,    43,    86,    36,    43,   104,    77,     3,    78,
      88,    41,    66,   298,    47,    85,     3,   133,   107,    73,
     133,   109,   182,    12,    13,   148,   143,   312,   145,     3,
      77,   148,   130,   131,   132,   133,    66,    91,     3,    86,
      94,   118,   144,    73,    82,     3,   148,    80,    89,    49,
      77,    83,   393,   107,    77,    82,    78,    77,    58,   113,
     100,    91,    85,    81,   162,   225,    86,    78,   101,   188,
     324,    81,   232,    81,    78,     3,    86,   107,     3,    89,
      99,    89,   268,   269,   270,    80,    81,   119,    88,   100,
     206,    78,   202,   206,    89,    77,    81,    97,    98,    99,
      82,    77,   102,   226,    78,   228,    95,    96,   206,   226,
      86,   228,    78,    78,    77,    58,   233,   234,   235,    82,
       7,     8,     9,    77,   226,    80,   228,   181,    82,   217,
      89,   291,   218,   252,    93,    94,   253,    62,    63,    64,
      65,    77,    81,     3,   144,    84,    82,   266,   148,    81,
     336,   181,    84,    86,    97,    98,    99,    89,   318,   102,
     193,    77,    77,    82,   218,   243,    82,    82,   287,   286,
     268,   269,   270,   271,   272,   273,   274,   275,   276,   277,
     278,   279,   280,   281,   282,   283,   284,   285,   218,    81,
     306,     3,    84,   306,    81,    77,    78,    84,    77,    77,
      87,   144,   202,    82,    82,   148,    77,    81,   306,    77,
      84,    82,   328,   332,    82,   328,   333,   334,    81,     3,
     309,    84,   382,   383,   384,    78,   226,    80,   228,    77,
     328,    77,    80,    79,   311,    90,    91,   314,   336,   275,
     276,   277,   278,    77,   298,    79,   365,   365,    81,   327,
      62,    63,    64,   100,   414,   309,    10,    11,   312,   202,
      77,    77,    79,    79,    14,    15,   271,   272,   385,   386,
      80,   304,   432,   327,    80,   435,   273,   274,   394,   309,
     399,   394,   401,   226,    81,   228,   279,   280,   407,    81,
      81,   404,    81,     3,    88,    97,   394,    98,    86,    86,
     377,    16,    82,    77,   423,    80,   404,    85,     3,    80,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
     439,   439,     3,     4,     5,     6,    82,     8,     9,    80,
      54,    86,    85,    77,    82,     3,     3,     3,     3,   393,
      78,    82,    82,    77,    81,    81,    78,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    85,    49,    50,
      51,    82,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    82,    52,    82,    86,    66,    67,    68,     3,     4,
       5,     6,   100,     8,     9,    85,   217,    78,    79,   313,
      81,   407,    83,   283,   281,    86,   408,    88,    89,    90,
      91,    92,   282,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,   284,    49,    50,    51,    89,    53,    54,
      55,    56,    57,    58,    59,    60,    61,   285,    97,    62,
     304,    66,    67,    68,     3,     4,     5,     6,   105,     8,
       9,    54,   113,    78,    79,   327,    81,   181,    83,   399,
     329,    86,    -1,    88,    89,    90,    91,    92,    -1,    28,
      -1,    -1,    -1,    -1,    -1,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,     3,
       4,     5,     6,    -1,     8,     9,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    66,    67,    68,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    81,    -1,    83,    -1,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    -1,    49,    50,    51,    -1,    53,
      54,    55,    56,    57,    58,    59,    60,    -1,    -1,    -1,
      -1,    -1,    66,    67,    68,     3,     4,     5,     6,    -1,
       8,     9,    -1,    -1,    78,    79,    -1,    81,    -1,    83,
      -1,    -1,    86,    -1,    88,    89,    90,    91,    92,    -1,
      -1,    28,    -1,    -1,    -1,    -1,    -1,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    49,    50,    51,    -1,    53,    54,    55,    56,    57,
      58,    59,    60,    -1,    -1,    -1,    -1,    -1,    66,    67,
      68,     3,     4,     5,     6,    -1,     8,     9,    -1,    -1,
      78,    79,    79,    81,    -1,    83,    -1,    -1,    86,    -1,
      88,    89,    90,    91,    92,    -1,    -1,    -1,     3,     4,
       5,     6,    -1,     8,     9,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    49,    50,    51,
      -1,    53,    54,    55,    56,    57,    58,    59,    60,    -1,
      -1,    -1,    -1,    -1,    66,    67,    68,     3,     4,     5,
       6,    -1,     8,     9,    -1,    -1,    78,    -1,    -1,    81,
      -1,    83,    -1,    -1,    86,    -1,    88,    89,    90,    91,
      92,    66,    67,    68,     3,     4,     5,     6,    -1,     8,
       9,    -1,    -1,    78,    79,    -1,    81,    -1,    83,    -1,
      -1,    -1,    -1,    88,    89,    90,    91,    92,    -1,    -1,
      -1,     3,     4,     5,     6,    -1,     8,     9,    -1,    -1,
      66,    67,    68,     3,     4,     5,     6,    -1,     8,     9,
      -1,    -1,    78,    79,    -1,    81,    -1,    83,    -1,    -1,
      -1,    -1,    88,    89,    90,    91,    92,    66,    67,    68,
       3,     4,     5,     6,    -1,     8,     9,    -1,    -1,    78,
      -1,    -1,    81,    -1,    83,    -1,    -1,    -1,    -1,    88,
      89,    90,    91,    92,    66,    67,    68,     3,     4,     5,
       6,    -1,     8,     9,    -1,    -1,    66,    67,    68,    81,
      -1,    83,    -1,    85,    -1,    -1,    88,    89,    90,    91,
      92,    81,    -1,    83,    -1,    -1,    86,    -1,    88,    89,
      90,    91,    92,    66,    67,    68,     3,     4,     5,     6,
      -1,     8,     9,    -1,    -1,    -1,    -1,    -1,    81,    -1,
      83,    84,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      66,    67,    68,     3,     4,     5,     6,    -1,     8,     9,
      -1,    -1,    -1,    -1,    -1,    81,    -1,    83,    -1,    -1,
      86,    -1,    88,    89,    90,    91,    92,    -1,    -1,    -1,
       3,     4,     5,     6,    -1,     8,     9,    -1,    -1,    66,
      67,    68,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    81,    82,    83,    -1,    -1,    -1,
      -1,    88,    89,    90,    91,    92,    66,    67,    68,     3,
       4,     5,     6,    -1,     8,     9,    -1,    -1,    -1,    -1,
      -1,    81,    -1,    83,    -1,    85,    -1,    -1,    88,    89,
      90,    91,    92,    66,    67,    68,     3,     4,     5,     6,
      -1,     8,     9,    -1,    -1,    78,    -1,    -1,    81,    -1,
      83,    -1,    -1,    -1,    -1,    88,    89,    90,    91,    92,
      -1,    -1,    -1,     3,     4,     5,     6,    -1,     8,     9,
      -1,    -1,    66,    67,    68,     3,     4,     5,     6,    -1,
       8,     9,    -1,    -1,    -1,    -1,    -1,    81,    82,    83,
      -1,    -1,    -1,    -1,    88,    89,    90,    91,    92,    66,
      67,    68,     3,     4,     5,     6,    -1,     8,     9,    -1,
      -1,    -1,    -1,    -1,    81,    -1,    83,    -1,    85,    -1,
      -1,    88,    89,    90,    91,    92,    66,    67,    68,     3,
       4,     5,     6,    -1,     8,     9,    -1,    -1,    66,    67,
      68,    81,    82,    83,    -1,    -1,    -1,    -1,    88,    89,
      90,    91,    92,    81,    -1,    83,    -1,    -1,    -1,    -1,
      88,    89,    90,    91,    92,    66,    67,    68,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      81,    -1,    83,    -1,    -1,    -1,    -1,    88,    89,    90,
      91,    92,    66,    67,    68,     3,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    81,    -1,    83,
      -1,    -1,    -1,    -1,    88,    89,    90,    91,    92,    -1,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,     3,    -1,    61,    62,    63,    64,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    79,    -1,    -1,    -1,    83,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,    -1,    61,
      62,    63,    64,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    79,    -1,    -1,
      -1,    83,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,     3,    -1,    61,    62,    63,    64,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    79,    -1,    -1,    -1,    83,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,
      28,    61,    62,    63,    64,    -1,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      -1,    -1,    -1,    83,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,     0,    28,    -1,    -1,    -1,    -1,    61,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    -1,    -1,    -1,    -1,    -1,    -1,    82,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    -1,
      -1,    -1,    -1,    79,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    61,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    72,    73,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    61,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    81,    82,
      -1,    84,    -1,    -1,    -1,    -1,    89,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      61,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    82,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    61,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    82,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    61,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    72,
      73,    -1,    -1,    -1,    -1,    -1,    79,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      61,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    72,    73,    -1,    -1,    -1,    -1,    -1,    79,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    61,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    72,    73,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    61,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    61
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    61,    72,    73,   103,   116,   117,   121,   122,   123,
     144,   147,   148,   149,   155,   158,   181,   182,     3,    78,
       3,    78,     3,    78,    72,   116,     3,    81,    86,    89,
     145,   146,   159,   160,   161,   116,   116,     3,    78,   116,
       0,   123,    78,     3,   156,   157,    78,    80,     3,    62,
      63,    64,    83,   106,   107,   108,   109,   110,   111,   115,
     116,   144,    78,   181,     3,   159,   158,   161,   162,    77,
      86,    78,   100,   174,    81,    84,   160,    78,   117,   150,
     151,   152,   158,   156,   100,    77,    79,   106,     3,    65,
     104,   105,   108,    81,     3,    79,   107,    80,   159,   181,
      79,    86,    82,   158,   161,   146,   159,     3,     4,     5,
       6,     8,     9,    49,    50,    51,    53,    54,    55,    56,
      57,    58,    59,    60,    66,    67,    68,    79,    81,    83,
      86,    88,    89,    90,    91,    92,   116,   118,   119,   120,
     124,   126,   127,   128,   129,   130,   131,   132,   133,   134,
     135,   136,   137,   138,   139,   140,   142,   144,   172,   173,
     174,   175,   176,   177,   178,   179,   180,     3,    78,   140,
     170,     3,    82,   116,   163,   164,   165,   166,    85,   126,
     139,   143,   150,   152,    79,   151,    80,   153,   154,   159,
     152,    79,   143,   157,    79,     3,   108,    77,    78,     3,
      82,   164,    81,   174,    79,    80,    81,   126,    81,   126,
     126,   143,    80,    81,    81,    81,   172,    81,     3,    86,
      86,    86,   142,   152,   167,    84,   142,   142,   167,     7,
       8,     9,    81,    84,    87,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,   100,   141,   128,    89,    93,
      94,    90,    91,    10,    11,    12,    13,    95,    96,    14,
      15,    88,    97,    98,    16,    17,    99,    77,    86,    79,
     144,   176,    79,   172,   170,   171,   159,    82,    77,    77,
      82,    85,    79,   143,    77,    86,    80,     3,   105,   106,
      80,   112,    77,    82,    82,   172,   167,   167,    80,   172,
     142,   142,   142,    54,   177,    86,    86,    81,    84,   161,
     168,   169,    81,    84,    85,    82,    82,     3,    82,   125,
     140,   142,     3,   140,   128,   128,   128,   129,   129,   130,
     130,   131,   131,   131,   131,   132,   132,   133,   134,   135,
     136,   137,   142,   140,    79,    77,    79,    48,   165,     3,
     154,   143,    79,     3,   113,   114,   174,   112,   174,    82,
      82,   172,    82,    82,    82,    81,   177,    82,   163,   168,
      85,   143,   169,    81,    84,   102,   140,   142,   142,    78,
     128,    77,    82,    85,    80,    79,   170,    81,    77,   174,
     172,   172,   172,   142,    82,   142,    82,    82,    85,    82,
     163,    85,   143,    77,    82,    85,   171,   140,   139,    82,
     102,   114,    52,    82,   172,    82,    82,    85,   140,    77,
      79,    82,   172,    86,   172,    79
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_uint8 yyr1[] =
{
       0,   101,   102,   102,   103,   103,   103,   103,   104,   104,
     105,   105,   105,   105,   106,   106,   107,   107,   108,   108,
     108,   109,   109,   109,   109,   110,   111,   111,   112,   112,
     113,   113,   114,   114,   115,   116,   116,   116,   116,   116,
     116,   116,   116,   117,   117,   117,   117,   117,   117,   117,
     117,   117,   117,   117,   117,   118,   118,   118,   119,   119,
     120,   120,   120,   120,   120,   121,   121,   122,   123,   123,
     123,   123,   124,   124,   124,   124,   124,   124,   124,   124,
     124,   124,   125,   125,   126,   126,   126,   126,   126,   126,
     126,   126,   127,   127,   127,   127,   127,   127,   128,   128,
     129,   129,   129,   129,   130,   130,   130,   131,   131,   131,
     132,   132,   132,   132,   132,   133,   133,   133,   134,   134,
     135,   135,   136,   136,   137,   137,   138,   138,   139,   139,
     140,   140,   141,   141,   141,   141,   141,   141,   141,   141,
     141,   141,   141,   142,   142,   143,   144,   144,   145,   145,
     146,   146,   147,   147,   147,   147,   147,   148,   148,   148,
     149,   149,   150,   150,   151,   152,   152,   152,   152,   153,
     153,   154,   154,   154,   155,   155,   155,   156,   156,   157,
     157,   158,   158,   159,   159,   160,   160,   160,   160,   160,
     160,   160,   161,   161,   161,   161,   162,   162,   163,   163,
     164,   164,   165,   165,   166,   166,   167,   167,   168,   168,
     168,   169,   169,   169,   169,   169,   169,   169,   169,   169,
     170,   170,   170,   171,   171,   172,   172,   172,   172,   172,
     172,   173,   173,   173,   174,   174,   174,   174,   175,   175,
     176,   176,   177,   177,   178,   178,   178,   179,   179,   179,
     179,   180,   180,   180,   180,   180,   181,   181,   182
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     3,     5,     7,     2,     4,     1,     3,
       1,     2,     2,     3,     1,     2,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     3,     6,     5,     2,     0,
       1,     3,     4,     3,     5,     1,     2,     1,     2,     1,
       2,     1,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     5,     5,     2,     4,
       1,     1,     1,     3,     1,     5,     4,     4,     1,     1,
       1,     1,     1,     4,     3,     4,     3,     3,     2,     2,
       6,     7,     1,     3,     1,     2,     2,     2,     2,     4,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     4,
       1,     3,     3,     3,     1,     3,     3,     1,     3,     3,
       1,     3,     3,     3,     3,     1,     3,     3,     1,     3,
       1,     3,     1,     3,     1,     3,     1,     3,     1,     5,
       1,     3,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     1,     2,     3,     1,     3,
       1,     3,     1,     1,     1,     1,     1,     5,     4,     2,
       1,     1,     1,     2,     3,     2,     1,     2,     1,     1,
       3,     1,     2,     3,     4,     5,     2,     1,     3,     1,
       3,     1,     1,     2,     1,     1,     3,     4,     3,     4,
       4,     3,     1,     2,     2,     3,     1,     2,     1,     3,
       1,     3,     2,     1,     1,     3,     1,     2,     1,     1,
       2,     3,     2,     3,     3,     4,     2,     3,     3,     4,
       1,     3,     4,     1,     3,     1,     1,     1,     1,     1,
       1,     3,     4,     3,     2,     3,     3,     4,     1,     2,
       1,     2,     1,     2,     5,     7,     5,     5,     7,     6,
       7,     3,     2,     2,     2,     3,     1,     2,     3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {

#line 2080 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 569 "prob1.y"

#include <stdio.h>

extern char yytext[];
extern int column;

/* yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
} */

int yyerror(char *s){
	
  
  printf("Error \n ");
  printf("%s \n",s);
  yyparse();
}

int main(int argc, char* argv[])
{

	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yyparse();
	return 0;
}
