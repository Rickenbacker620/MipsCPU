with open("src/data.dat", "w") as mock:
    for i in range(1, 65):
        mockstr = str(i).rjust(2, "0")
        mock.write("{}\n".format(mockstr*4))
