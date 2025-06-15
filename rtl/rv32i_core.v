`timescale 1ns/1ps
module rv32i_core #(parameter XLEN=32, REG_COUNT=32)
(input wire clk, rst, input wire [31:0] instr, mem_rdata, output reg [31:0] pc, output wire [31:0] mem_addr, mem_wdata, output wire mem_we);

  wire [6:0] opcode=instr[6:0];
  wire [4:0] rd=instr[11:7];
  wire [2:0] funct3=instr[14:12];
  wire [4:0] rs1=instr[19:15];
  wire [4:0] rs2=instr[24:20];
  wire [6:0] funct7=instr[31:25];

  wire [31:0] reg_rdata1, reg_rdata2, alu_result;
  wire [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

  assign imm_i={{20{instr[31]}},instr[31:20]};
  assign imm_s={{20{instr[31]}},instr[31:25],instr[11:7]};
  assign imm_b={{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
  assign imm_u={instr[31:12],12'b0};
  assign imm_j={{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};

  wire writeback_en;
  wire [31:0] writeback_data;

  reg_file regfile(.clk(clk),.rs1(rs1),.rs2(rs2),.rd(rd),.we(writeback_en),.wd(writeback_data),.rd1(reg_rdata1),.rd2(reg_rdata2));

  alu alu_inst(.a(reg_rdata1),.b((opcode==7'b0010011 || opcode==7'b0000011)?imm_i:reg_rdata2),
  .funct3(funct3),.funct7(funct7),.opcode(opcode),.result(alu_result));

  assign writeback_en=(opcode==7'b0010011 || opcode==7'b0110011 || opcode==7'b0000011 || opcode==7'b1101111 || opcode==7'b1100111 || opcode==7'b0010111 || opcode==7'b0110111);

  assign writeback_data=(opcode==7'b0000011)?mem_rdata:
                        (opcode==7'b1101111 || opcode==7'b1100111)?pc+4:
                        (opcode==7'b0010111 || opcode==7'b0110111)?imm_u:alu_result;

  //Registered memory control signals
  reg [31:0] mem_addr_reg, mem_wdata_reg;
  reg mem_we_reg;

  assign mem_addr=mem_addr_reg;
  assign mem_wdata=mem_wdata_reg;
  assign mem_we=mem_we_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pc<=32'h00000000;
      mem_we_reg<=0;
      mem_addr_reg<=0;
      mem_wdata_reg<=0;
    end else begin
      //PC update
      case (opcode)
        7'b1100011: begin //Branches
          case (funct3)
            3'b000: pc<=(reg_rdata1==reg_rdata2) ? pc+imm_b : pc+4; //BEQ
            3'b001: pc<=(reg_rdata1 != reg_rdata2) ? pc+imm_b : pc+4; //BNE
            3'b100: pc<=($signed(reg_rdata1) < $signed(reg_rdata2)) ? pc+imm_b : pc+4; //BLT
            3'b101: pc<=($signed(reg_rdata1) >= $signed(reg_rdata2)) ? pc+imm_b : pc+4; //BGE
            3'b110: pc<=(reg_rdata1 < reg_rdata2) ? pc+imm_b : pc+4; //BLTU
            3'b111: pc<=(reg_rdata1 >= reg_rdata2) ? pc+imm_b : pc+4; //BGEU
            default: pc<=pc+4;
          endcase
        end

        7'b1101111: pc<=pc+imm_j; //JAL
        7'b1100111: pc<=(reg_rdata1+imm_i) & ~32'b1; //JALR
        default: pc<=pc+4;
      endcase

      //Memory Access
      mem_we_reg<=0;

      case (opcode)
        7'b0100011: begin //SW
          mem_addr_reg<=reg_rdata1+imm_s;
          mem_wdata_reg<=reg_rdata2;
          mem_we_reg<=1;
        end
        7'b0000011: begin //LW
          mem_addr_reg<=reg_rdata1+imm_i;
          mem_we_reg<=0;
        end
        default: begin
          mem_we_reg<=0;
        end
      endcase
    end
  end

endmodule
