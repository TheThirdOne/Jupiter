package vsim.riscv.instructions.stype;

import vsim.Globals;


public final class Sw extends SType {

  public Sw() {
    super(
      "sw",
      "sw rs2, offset(rs1)",
      "set memory[rs1 + sext(offset)] = rs2[31:0]"
    );
  }

  @Override
  public int getFunct3() {
    return 0b010;
  }

  @Override
  protected void setMemory(int rs1, int rs2, int imm) {
    Globals.memory.storeWord(rs1 + imm, rs2);
  }

}
