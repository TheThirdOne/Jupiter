/*
Copyright (C) 2018 Andres Castellanos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
*/

package vsim.riscv.instructions.rtype;


/**
 * The Xor class represents a xor instruction.
 */
public final class Xor extends RType {

  /**
   * Unique constructor that initializes a newly Xor instruction.
   *
   * @see vsim.riscv.instructions.rtype.RType
   */
  public Xor() {
    super(
      "xor",
      "xor rd, rs1, rs2",
      "set x[rd] = x[rs1] ^ x[rs2], bitwise xor"
    );
  }

  @Override
  public int getFunct3() {
    return 0b100;
  }

  @Override
  protected int compute(int rs1, int rs2) {
    return rs1 ^ rs2;
  }

}
