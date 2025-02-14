import xlrd
import re
import os

def parse_register_file(filename):
    """
    解析包含多个寄存器信息的 Excel 文件。

    Args:
        filename (str): Excel 文件的名称。

    Returns:
        tuple: 包含模块名称和寄存器信息的字典列表的元组。
    """
    try:
        workbook = xlrd.open_workbook(filename)
        worksheet = workbook.sheet_by_index(0)  # 假设数据在第一个工作表中

        # 查找模块名称
        module_name = None
        for row_index in range(worksheet.nrows):
            if worksheet.cell_value(row_index, 0).startswith('Module'):
                module_name = worksheet.cell_value(row_index, 0).split(' ')[1].strip()
                break

        if not module_name:
            print("错误：未找到模块名称。")
            return None, None

    except FileNotFoundError:
        print(f"错误：文件 '{filename}' 未找到。")
        return None, None
    except Exception as e:
        print(f"打开文件时发生错误：{e}")
        return None, None

    registers = []
    row_index = 0
    while row_index < worksheet.nrows:
        # 检查是否为寄存器起始行
        if worksheet.cell_value(row_index, 0) == 'Register':
            # 读取寄存器通用信息
            register_name = worksheet.cell_value(row_index, 1).strip()
            address = int(worksheet.cell_value(row_index + 1, 1), 16)  # 将十六进制字符串转换为整数
            default_value = worksheet.cell_value(row_index + 2, 1).strip()
            if default_value.startswith('0x'):
                default = int(default_value, 16)
            else:
                default = 0
            width = int(worksheet.cell_value(row_index + 3, 1))

            # 读取位字段信息
            fields = []
            field_row_index = row_index + 6
            # 修改循环条件，确保至少读取一个位字段
            while field_row_index < worksheet.nrows:
                bit_position_str = worksheet.cell_value(field_row_index, 0).strip()
                if '[' in bit_position_str and ']' in bit_position_str:
                    bit_position = bit_position_str.replace('[','').replace(']','')
                    field_name = worksheet.cell_value(field_row_index, 1).strip()
                    access = worksheet.cell_value(field_row_index, 2).strip()
                    default_value = worksheet.cell_value(field_row_index, 3).strip()
                    description = worksheet.cell_value(field_row_index, 4).strip()

                    fields.append({
                        'bit_position': bit_position,
                        'field_name': field_name,
                        'access': access,
                        'default_value': default_value,
                        'description': description
                    })
                else:
                    #empty line
                    break

                field_row_index += 1

            register_info = {
                'register_name': register_name,
                'address': address,
                'default': default,
                'width': width,
                'fields': fields
            }
            registers.append(register_info)

            row_index = field_row_index  # 更新行索引到下一个寄存器
        else:
            row_index += 1

    return module_name, registers

def generate_ralf(module_name, registers, output_filename):
    """
    将寄存器信息转换为 RAF 格式，并将其保存到文件中。

    Args:
        module_name (str): 模块名称。
        registers (list): 寄存器信息的字典列表。
        output_filename (str): 输出 RALF 文件的名称。
    """
    with open(output_filename, 'w') as f:

        for register_info in registers:
            register_name = register_info['register_name']
            address = register_info['address']
            default = register_info['default']
            width = register_info['width']
            fields = register_info['fields']

            f.write(f'register {register_name.upper()} {{\n')
            #f.write(f'  offset = 0x{address:04X};\n')
            #f.write(f'  reset  = 0x{default:0{width // 4}X};\n')

            for field in fields:
                bit_position = field['bit_position']
                field_name = field['field_name']
                reset = field['default_value']
                access = field['access']
                description = field['description']

                # 检查 bit_position 是否为字符串类型，并且包含 ":"
                if isinstance(bit_position, str) and ':' in bit_position:
                    num_tmp = re.compile('\d+')
                    num = num_tmp.findall(bit_position)
                    f.write("   field %s (%s) @'h%s {\n" %(field_name,field_name,num[1]))
                    bit_num = int(num[0])-int(num[1])+1
                    f.write("     bits %s;\n" %(bit_num))
                else:
                    f.write("   field %s (%s) @'h%s {\n" % (field_name, field_name, bit_position))
                    f.write("     bits 1;\n")

                f.write(f'     reset {reset};\n')
                f.write("     access %s;\n" % (access.lower()))
            f.write('     }\n')
            f.write('}\n')

        f.write(f'block {module_name}  {{\n')
        f.write('  bytes  4;\n')
        for register_info in registers:
            register_name = register_info['register_name']
            address = register_info['address']
            default = register_info['default']
            width = register_info['width']
            f.write(f'  register {register_name.upper()} (u_{module_name}_apb.U_{module_name.upper()}_REG)@\'h{address:04X};\n')
        f.write('}\n')

# 使用示例
if __name__ == "__main__":
    excel_filename = input("请输入 Excel 文件名（包含扩展名，例如 reg.xls）：")
    excel_basename = os.path.splitext(excel_filename)[0]  # 获取不包含扩展名的文件名

    register_file = excel_filename
    module_name, registers = parse_register_file(register_file)

    if registers:
        output_file = f'{module_name}.ralf'
        generate_ralf(module_name, registers, output_file)
        print(f"RALF 文件 '{output_file}' 生成成功。")
