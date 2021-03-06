import yaml

configDict = {}

with open("../constrain/constr.yaml") as ym:
    configDict = yaml.load(ym)

with open("../constrain/constr_1.xdc", "w") as constrain:
    for variable, port in configDict.items():
        constrain.write(
            "set_property PACKAGE_PIN {} [get_ports {}]\n".format(port, variable))
        constrain.write(
            "set_property IOSTANDARD LVCMOS33 [get_ports {}]\n".format(variable))
