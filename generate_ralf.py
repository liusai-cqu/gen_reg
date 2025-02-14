import xlrd

def parse_register_file(filename):
    """
    解析包含多个寄存器信息的 Excel 文件。

    Args:
        filename (str): Excel 文件的名称。

    Returns:
        list: 寄存器信息的字典列表。
    """
    try:
        workbook = xlrd.open_workbook(filename)
        worksheet = workbook.sheet_by_index(0)  # 假设数据在第一个工作表中
    except FileNotFoundError:
        print(f"错误：文件 '{filename}' 未找到。")
        return None
    except Exception as e:
        print(f"打开文件时发生错误：{e}")
        return None

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
            field_row_index = row_index + 5
            while field_row_index < worksheet.nrows and worksheet.cell_value(field_row_index, 0) != '':
                bit_position_str = worksheet.cell_value(field_row_index, 0).strip()
                if '[' in bit_position_str and ']' in bit_position_str:
                    bit_position = bit_position_str.replace('[','').replace(']','')
                else:
                    bit_position = 0
                alias_name = worksheet.cell_value(field_row_index, 1).strip()
                access = worksheet.cell_value(field_row_index, 2).strip()
                default_value = worksheet.cell_value(field_row_index, 3).strip()
                description = worksheet.cell_value(field_row_index, 4).strip()

                fields.append({
                    'bit_position': bit_position,
                    'alias_name': alias_name,
                    'access': access,
                    'default_value': default_value,
                    'description': description
                })

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

    return registers

def generate_ralf(registers, output_filename):
    """
    将寄存器信息转换为 RALF 格式，并将其保存到文件中。

    Args:
        registers (list): 寄存器信息的字典列表。
        output_filename (str): 输出 RALF 文件的名称。
    """
    with open(output_filename, 'w') as f:
        f.write('ralf_version = "2.0";\n\n')
        f.write('block top {\n')

        for register_info in registers:
            register_name = register_info['register_name']
            address = register_info['address']
            default = register_info['default']
            width = register_info['width']
            fields = register_info['fields']

            f.write(f'  reg {register_name} "" {{\n')
            f.write(f'    offset = 0x{address:04X};\n')
            f.write(f'    reset = 0x{default:0{width // 4}X};\n')

            for field in fields:
                bit_position = field['bit_position']
                alias_name = field['alias_name']
                access = field['access']
                description = field['description']

                # 检查 bit_position 是否为字符串类型，并且包含 ":"
                if isinstance(bit_position, str) and ':' in bit_position:
                    f.write(f'    field {{ width = {width}; offset = {bit_position}; access = {access.lower()}; name = {alias_name}; desc = "{description}"; }}\n')
                else:
                    f.write(f'    field {{ width = 1; offset = {bit_position}; access = {access.lower()}; name = {alias_name}; desc = "{description}"; }}\n')

            f.write('  }\n')
        f.write('}\n')

# 使用示例
if __name__ == "__main__":
    register_file = 'reg.xls'
    output_file = 'registers.ralf'
    registers = parse_register_file(register_file)

    if registers:
        generate_ralf(registers, output_file)
        print(f"RALF 文件 '{output_file}' 生成成功。")