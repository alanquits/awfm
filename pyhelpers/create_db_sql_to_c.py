import os

infile = os.path.join("..", "resources", "create_db.sql")
outfile = os.path.join("..", "resources", "create_db")

with open(infile, "r") as f_in:
    with open(outfile + ".h", "w") as f_out:
        f_out.write("#ifndef CREATE_DB_H\n")
        f_out.write("#define CREATE_DB_H\n\n")
        f_out.write("#include <QString>\n\n")
        f_out.write('extern QString CREATE_DB_DEFINITION;\n')
        f_out.write("#endif")

    with open(outfile + ".cpp", "w") as f_out:
        f_out.write('#include "create_db.h"\n\n')
        f_out.write("QString CREATE_DB_DEFINITION = \n")
        for line in f_in.read().split("\n"):
            if not line:
                f_out.write("\n")
            else:
                f_out.write('    "%s"\n' %line)
        f_out.write(";")
