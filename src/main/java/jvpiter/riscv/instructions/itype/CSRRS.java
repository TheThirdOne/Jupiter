/*
Copyright (C) 2018-2019 Andres Castellanos

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

package jvpiter.riscv.instructions.itype;

import jvpiter.exc.SimulationException;
import jvpiter.riscv.instructions.Format;
import jvpiter.riscv.instructions.Instruction;
import jvpiter.riscv.instructions.InstructionField;
import jvpiter.riscv.instructions.MachineCode;
import jvpiter.sim.State;
import jvpiter.utils.Data;


/** RISC-V csrrs (Control and Status Register Read and Set) instruction. */
public final class CSRRS extends Instruction {

  /** Creates a new csrrs instruction. */
  public CSRRS() {
    super(Format.I, "csrrs", 0b1110011, 0b010, 0b0000000);
  }

  /** {@inheritDoc} */
  @Override
  public void execute(MachineCode code, State state) throws SimulationException {
    // TODO: implement this
    state.xregfile().incProgramCounter();
  }

  /** {@inheritDoc} */
  @Override
  public String disassemble(MachineCode code) {
    int rd = code.get(InstructionField.RD);
    int rs1 = code.get(InstructionField.RS1);
    int csr = Data.imm(code, Format.I) & 0xfff;
    return String.format("csrrs x%d, %d, x%d", rd, csr, rs1);
  }

}