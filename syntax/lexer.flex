package vsim.assembler.syntax;

%%

%{

  private int prevState;
  private StringBuffer text;

  private java_cup.runtime.Symbol symbol(int type) {
    return this.symbol(type, null);
  }

  private java_cup.runtime.Symbol symbol(int type, Object value) {
    return new java_cup.runtime.Symbol(type, yyline, yycolumn, value);
  }

%}

%init{
  this.prevState = YYINITIAL;
  this.text = new StringBuffer(0);
%init}

%eofval{
  int state = yystate();
  if (state == STRING || state == SBACKSLASH && this.prevState == STRING) {
    yybegin(YYINITIAL);
    return symbol(Token.ERROR, "unterminated string constant");
  } else if (state == CHARACTER || state == SBACKSLASH && this.prevState == CHARACTER) {
    yybegin(YYINITIAL);
    return symbol(Token.ERROR, "unterminated char constant");
  }
  return symbol(Token.EOF);
%eofval}


%public
%class Lexer
%final
%cup
%line
%column
%full

%state STRING
%state SBACKSLASH
%state CHARACTER

// syntax
COMMA = ","
COLON = ":"
LPAREN = "("
RPAREN = ")"
DOT = "."

// operators
TIMES = "*"
DIVIDE = "/"
MOD = "%"
PLUS = "+"
MINUS = "-"
SLL = "<<"
SRL = ">>"
AND = "&"
OR = "|"
XOR = "^"
NEG = "~"

// strings and chars
STRSTART = \"
BACKSLASH = "\\"
CHAR = .
CHARSTART = \'

// directives
D_ZERO = ".zero"
D_ASCIIZ = ".asciiz"
D_STRING = ".string"
D_BYTE = ".byte"
D_HALF = ".half"
D_WORD = ".word"
D_ALIGN = ".align"
D_GLOBAL = ".globl"
D_LOCAL = ".local"
D_FILE = ".file"
D_SECTION = ".section"
D_DATA = ".data"
D_TEXT = ".text"
D_RODATA = ".rodata"
D_BSS = ".bss"

// B Format
I_BEQ = [bB][eE][qQ]
I_BGE = [bB][gG][eE]
I_BGEU = [bB][gG][eE][uU]
I_BLT = [bB][lL][tT]
I_BLTU = [bB][lL][tT][uU]
I_BNE = [bB][nN][eE]

// U Format
I_AUIPC = [aA][uU][iI][pP][cC]
I_LUI = [lL][uU][iI]

// J Format
I_JAL = [jJ][aA][lL]

// R Format
I_ADD = [aA][dD][dD]
I_AND = [aA][nN][dD]
I_DIVU = [dD][iI][vV][uU]
I_DIV = [dD][iI][vV]
I_MULHSU = [mM][uU][lL][hH][sS][uU]
I_MULHU = [mM][uU][lL][hH][uU]
I_MULH = [mM][uU][lL][hH]
I_MUL = [mM][uU][lL]
I_OR = [oO][rR]
I_REMU = [rR][eE][mM][uU]
I_REM = [rR][eE][mM]
I_SLTU = [sS][lL][tT][uU]
I_SLL = [sS][lL][lL]
I_SLT = [sS][lL][tT]
I_SRA = [sS][rR][aA]
I_SRL = [sS][rR][lL]
I_SUB = [sS][uU][bB]
I_XOR = [xX][oO][rR]

// I Format
I_ADDI = [aA][dD][dD][iI]
I_ANDI = [aA][nN][dD][iI]
I_ECALL = [eE][cC][aA][lL]
I_JALR = [jJ][aA][lL][rR]
I_LB = [lL][bB]
I_LBU = [lL][bB][uU]
I_LH = [lL][hH]
I_LHU = [lL][hH][uU]
I_LW = [lL][wW]
I_ORI = [oO][rR][iI]
I_SLLI = [sS][lL][lL][iI]
I_SLTI = [sS][lL][tT][iI]
I_SLTIU = [sS][lL][tT][iI][uU]
I_SRAI = [sS][rR][aA][iI]
I_SRLI = [sS][rR][lL][iI]
I_XORI = [xX][oO][rR][iI]

// S Format
I_SB = [sS][bB]
I_SH = [sS][hH]
I_SW = [sS][wW]

// Pseudos
I_LA = [lL][aA]
I_NOP = [nN][oO][pP]
I_LI = [lL][iI]
I_MV = [mM][vV]
I_NOT = [nN][oO][tT]
I_NEG = [nN][eE][gG]
I_SEQZ = [sS][eE][qQ][zZ]
I_SNEZ = [sS][nN][eE][zZ]
I_SLTZ = [sS][lL][tT][zZ]
I_SGTZ = [sS][gG][tT][zZ]
I_BEQZ = [bB][eE][qQ][zZ]
I_BNEZ = [bB][nN][eE][zZ]
I_BLEZ = [bB][lL][eE][zZ]
I_BGEZ = [bB][gG][eE][zZ]
I_BLTZ = [bB][lL][tT][zZ]
I_BGTZ = [bB][gG][tT][zZ]
I_BGT = [bB][gG][tT]
I_BLE = [bB][lL][eE]
I_BGTU = [bB][gG][tT][uU]
I_BLEU = [bB][lL][eE][uU]
I_J = [jJ]
I_JR = [jJ][rR]
I_RET = [rR][eE][tT]
I_CALL = [cC][aA][lL][lL]
I_TAIL = [tT][aA][iI][lL]

// registers
R_NUMBER = [xX]([0-9]|[12][0-9]|[3][01])
R_NAME = ("zero"|"ra"|"sp"|"gp"|"tp"|"fp"|"t"[0-6]|"a"[0-7]|"s"([0-9]|1[01]))
REGISTER = ({R_NUMBER}|{R_NAME})

// ids
IDENTIFIER = [a-zA-Z_][a-zA-Z0-9_]*

// numbers
NUMBER = [0-9]+
HEXADECIMAL = 0[xX][0-9a-fA-F]+
BINARY = 0[bB][01]+

// valid whitespace
WHITESPACE = (" "|\t)

// everything else error
ERROR = .
%%

<YYINITIAL>{

  // syntax symbols
  {COMMA}  {
    return symbol(Token.COMMA);
  }

  {COLON} {
    return symbol(Token.COLON);
  }

  {LPAREN} {
    return symbol(Token.LPAREN);
  }

  {RPAREN} {
    return symbol(Token.RPAREN);
  }

  {DOT} {
    return symbol(Token.DOT);
  }

  // operators
  {TIMES} {
    return symbol(Token.TIMES);
  }

  {DIVIDE} {
    return symbol(Token.DIVIDE);
  }

  {MOD} {
    return symbol(Token.MOD);
  }

  {PLUS} {
    return symbol(Token.PLUS);
  }

  {MINUS} {
    return symbol(Token.MINUS);
  }

  {SLL} {
    return symbol(Token.SLL);
  }

  {SRL} {
    return symbol(Token.SRL);
  }

  {AND} {
    return symbol(Token.AND);
  }

  {OR} {
    return symbol(Token.OR);
  }

  {XOR} {
    return symbol(Token.XOR);
  }

  {NEG} {
    return symbol(Token.NEG);
  }

  // strings
  {STRSTART} {
    this.text.setLength(0);
    yybegin(STRING);
  }

  // chars
  {CHARSTART} {
    this.text.setLength(0);
    yybegin(CHARACTER);
  }

  // directives
  {D_ZERO} {
    return symbol(Token.D_ZERO);
  }

  {D_ASCIIZ} {
    return symbol(Token.D_ASCIIZ);
  }

  {D_STRING} {
    return symbol(Token.D_STRING);
  }

  {D_BYTE} {
    return symbol(Token.D_BYTE);
  }

  {D_HALF} {
    return symbol(Token.D_HALF);
  }

  {D_WORD} {
    return symbol(Token.D_WORD);
  }

  {D_ALIGN} {
    return symbol(Token.D_ALIGN);
  }

  {D_GLOBAL} {
    return symbol(Token.D_GLOBAL);
  }

  {D_LOCAL} {
    return symbol(Token.D_LOCAL);
  }

  {D_FILE} {
    return symbol(Token.D_FILE);
  }

  {D_SECTION} {
    return symbol(Token.D_SECTION);
  }

  {D_DATA} {
    return symbol(Token.D_DATA);
  }

  {D_TEXT} {
    return symbol(Token.D_TEXT);
  }

  {D_RODATA} {
    return symbol(Token.D_RODATA);
  }

  {D_BSS} {
    return symbol(Token.D_BSS);
  }

  // B Format
  {I_BEQ} {
    return symbol(Token.I_BEQ);
  }

  {I_BGE} {
    return symbol(Token.I_BGE);
  }

  {I_BGEU} {
    return symbol(Token.I_BGEU);
  }

  {I_BLT} {
    return symbol(Token.I_BLT);
  }

  {I_BLTU} {
    return symbol(Token.I_BLTU);
  }

  {I_BNE} {
    return symbol(Token.I_BNE);
  }

  // U Format
  {I_AUIPC} {
    return symbol(Token.I_AUIPC);
  }

  {I_LUI} {
    return symbol(Token.I_LUI);
  }

  // J Format
  {I_JAL} {
    return symbol(Token.I_JAL);
  }

  // S Format
  {I_SB} {
    return symbol(Token.I_SB);
  }

  {I_SH} {
    return symbol(Token.I_SH);
  }

  {I_SW} {
    return symbol(Token.I_SW);
  }

  // R Format
  {I_ADD} {
    return symbol(Token.I_ADD);
  }

  {I_AND} {
    return symbol(Token.I_AND);
  }

  {I_DIV} {
    return symbol(Token.I_DIV);
  }

  {I_DIVU} {
    return symbol(Token.I_DIVU);
  }

  {I_MULHSU} {
    return symbol(Token.I_MULHSU);
  }

  {I_MULHU} {
    return symbol(Token.I_MULHU);
  }

  {I_MUL} {
    return symbol(Token.I_MUL);
  }

  {I_MULH} {
    return symbol(Token.I_MULH);
  }

  {I_OR} {
    return symbol(Token.I_OR);
  }

  {I_REM} {
    return symbol(Token.I_REM);
  }

  {I_REMU} {
    return symbol(Token.I_REMU);
  }

  {I_SLTU} {
    return symbol(Token.I_SLTU);
  }

  {I_SLL} {
    return symbol(Token.I_SLL);
  }

  {I_SLT} {
    return symbol(Token.I_SLT);
  }

  {I_SRA} {
    return symbol(Token.I_SRA);
  }

  {I_SRL} {
    return symbol(Token.I_SRL);
  }

  {I_SUB} {
    return symbol(Token.I_SUB);
  }

  {I_XOR} {
    return symbol(Token.I_XOR);
  }

  // I Format
  {I_ADDI} {
    return symbol(Token.I_ADDI);
  }

  {I_ANDI} {
    return symbol(Token.I_ANDI);
  }

  {I_ECALL} {
    return symbol(Token.I_ECALL);
  }

  {I_JALR} {
    return symbol(Token.I_JALR);
  }

  {I_LB} {
    return symbol(Token.I_LB);
  }

  {I_LBU} {
    return symbol(Token.I_LBU);
  }

  {I_LH} {
    return symbol(Token.I_LH);
  }

  {I_LHU} {
    return symbol(Token.I_LHU);
  }

  {I_LW} {
    return symbol(Token.I_LW);
  }

  {I_ORI} {
    return symbol(Token.I_ORI);
  }

  {I_SLLI} {
    return symbol(Token.I_SLLI);
  }

  {I_SLTI} {
    return symbol(Token.I_SLTI);
  }

  {I_SLTIU} {
    return symbol(Token.I_SLTIU);
  }

  {I_SRAI} {
    return symbol(Token.I_SRAI);
  }

  {I_SRLI} {
    return symbol(Token.I_SRLI);
  }

  {I_XORI} {
    return symbol(Token.I_XORI);
  }

  // Pseudos
  {I_LA} {
    return symbol(Token.I_LA);
  }

  {I_NOP} {
    return symbol(Token.I_NOP);
  }

  {I_LI} {
    return symbol(Token.I_LI);
  }

  {I_MV} {
    return symbol(Token.I_MV);
  }

  {I_NOT} {
    return symbol(Token.I_NOT);
  }

  {I_NEG} {
    return symbol(Token.I_NEG);
  }

  {I_SEQZ} {
    return symbol(Token.I_SEQZ);
  }

  {I_SNEZ} {
    return symbol(Token.I_SNEZ);
  }

  {I_SLTZ} {
    return symbol(Token.I_SLTZ);
  }

  {I_SGTZ} {
    return symbol(Token.I_SGTZ);
  }

  {I_BEQZ} {
    return symbol(Token.I_BEQZ);
  }

  {I_BNEZ} {
    return symbol(Token.I_BNEZ);
  }

  {I_BLEZ} {
    return symbol(Token.I_BLEZ);
  }

  {I_BGEZ} {
    return symbol(Token.I_BGEZ);
  }

  {I_BLTZ} {
    return symbol(Token.I_BLTZ);
  }

  {I_BGTZ} {
    return symbol(Token.I_BGTZ);
  }

  {I_BGT} {
    return symbol(Token.I_BGT);
  }

  {I_BLE} {
    return symbol(Token.I_BLE);
  }

  {I_BGTU} {
    return symbol(Token.I_BGTU);
  }

  {I_BLTU} {
    return symbol(Token.I_BLTU);
  }

  {I_BLEU} {
    return symbol(Token.I_BLEU);
  }

  {I_J} {
    return symbol(Token.I_J);
  }

  {I_JR} {
    return symbol(Token.I_JR);
  }

  {I_RET} {
    return symbol(Token.I_RET);
  }

  {I_CALL} {
    return symbol(Token.I_CALL);
  }

  {I_TAIL} {
    return symbol(Token.I_TAIL);
  }

  // registers
  {REGISTER} {
    return symbol(Token.REGISTER, yytext());
  }

  // identifiers
  {IDENTIFIER} {
      return symbol(Token.IDENTIFIER, yytext());
  }

  // number
  {NUMBER} {
    try {
      return symbol(Token.NUMBER, Integer.parseUnsignedInt(yytext()));
    } catch (Exception e) {
      return symbol(Token.ERROR, "invalid number constant: " + yytext());
    }
  }

  // hex number
  {HEXADECIMAL} {
    try {
      return symbol(Token.NUMBER,   Integer.parseUnsignedInt(yytext().substring(2), 16));
    } catch (Exception e) {
      return symbol(Token.ERROR, "invalid hexadecimal constant: " + yytext());
    }
  }

  // binary number
  {BINARY} {
    try {
      return symbol(Token.NUMBER, Integer.parseUnsignedInt(yytext().substring(2), 2));
    } catch (Exception e) {
      return symbol(Token.ERROR, "invalid binary constant: " + yytext());
    }
  }

  // ignore whitespace
  {WHITESPACE} { /* do nothing */ }

  // report error
  {ERROR}  {
    return symbol(Token.ERROR, "unexpected character: " + yytext());
  }

}

<STRING> {

  {BACKSLASH} {
    this.prevState = STRING;
    yybegin(SBACKSLASH);
  }

  {STRSTART} {
    yybegin(YYINITIAL);
    return symbol(Token.STRING, this.text.toString());
  }

  {CHAR} {
    this.text.append(yytext());
  }

}

<CHARACTER> {

  {BACKSLASH} {
    this.prevState = CHARACTER;
    yybegin(SBACKSLASH);
  }

  {CHARSTART} {
    yybegin(YYINITIAL);
    String ch = this.text.toString();
    if (ch.length() == 1)
      return symbol(Token.CHARACTER, this.text.toString().charAt(0));
    else
      return symbol(Token.ERROR, "invalid char: " + ch);
  }

  {CHAR} {
    this.text.append(yytext());
  }

}

<SBACKSLASH> {

  "0" {
    this.text.append('\0');
    yybegin(this.prevState);
  }

  "n" {
    this.text.append('\n');
    yybegin(this.prevState);
  }

  "t" {
    this.text.append('\t');
    yybegin(this.prevState);
  }

  "f" {
    this.text.append('\f');
    yybegin(this.prevState);
  }

  "b" {
    this.text.append('\b');
    yybegin(this.prevState);
  }

  "v" {
    this.text.append((char)11);
    yybegin(this.prevState);
  }

  "\"" {
    this.text.append("\"");
    yybegin(this.prevState);
  }

  "\'" {
    this.text.append("\'");
    yybegin(this.prevState);
  }

  "\n" {
    this.text.append("\n");
    yybegin(this.prevState);
  }

  "\\" {
    this.text.append("\\");
    yybegin(this.prevState);
  }

  {CHAR} {
    this.text.append(yytext());
    yybegin(this.prevState);
  }

}
