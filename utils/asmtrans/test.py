from string import Template

opdict = {
    "ori": "{op1} | {op2}",
    "andi": "{op1} & {op2}",
    "xori": "{op1} ^ {op2}",
    "nori": "~({op1} | {op2})"
}

registers = {
    "$0": 0, "$1": 0, "$2": 0, "$3": 0, "$4": 0, "$5": 0, "$6": 0, "$7": 0, "$8": 0, "$9": 0, "$10": 0, "$11": 0, "$12": 0, "$13": 0, "$14": 0, "$15": 0, "$16": 0, "$17": 0, "$18": 0, "$19": 0, "$20": 0, "$21": 0, "$22": 0, "$23": 0, "$24": 0, "$25": 0, "$26": 0, "$27": 0, "$28": 0, "$29": 0, "$30": 0, "$31": 0, "$32": 0
}


def parse(line):
    [operator, other] = line.split(' ')
    [rd, rs, imm] = other.split(',')
    expression = opdict[operator].format(op1=registers[rs], op2=imm)
    registers[rd] = eval(expression)
    print(line)
    print("0x%04x" % (registers[rd] & 0xffff))


with open("inst.dat") as inst:
    for line in inst:
        line = line.strip()
        parse(line)
