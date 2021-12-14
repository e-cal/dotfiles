import os

if __name__ == "__main__":
    try:
        f = open("/home/ecal/change.txt", "w")
    except:
        f = open("/home/ecal/change.txt", "x")

    CMD = "bw list items"
    check = ["", ""]

    raw = os.popen(CMD).readlines()
    raw = raw[0]
    split = raw.split("},{")
    for entry in split:
        for chunk in check:
            if chunk in entry:
                f.write("\n")
                for item in entry.split(','):
                    if not "Revision" in item and not "match" in item:
                        if "password" in item:
                            f.write(item + "\n")
                        elif "uri" in item:
                            f.write(item[:len(item)-2] + "\n")
    f.close()
