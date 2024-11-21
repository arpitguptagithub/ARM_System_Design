// Function to list all available commands
func ls() {
    print "fibonacci"
    print "prime"
    print "sort"
    print "help"
    print "sum"
    print "add"
    print "helloworld"
    print "factorial"
}

// Function to open and display a specific file (simulated command)
func cat() {
    input()
    if (buffer_size == 0) {
        print "No file specified"
        return
    }
    if (buffer == "fibonacci") {
        sys_exec("fibonacci");
        return
    }
    if (buffer == "prime") {
        sys_exec("prime");
        return
    }
    if (buffer == "sort") {
        sys_exec("sort");
        return
    }
    if (buffer == "help") {
        sys_exec("help");
        return
    }
    if (buffer == "sum") {
        sys_exec("sum");
        return
    }
    if (buffer == "add") {
        sys_exec("add");
        return
    }
    if (buffer == "helloworld") {
        sys_exec("helloworld");
        return
    }
    if (buffer == "factorial") {
        sys_exec("factorial");
        return
    }

}

// Function to echo input (print back what the user types)
func echo() {
    input()
    output()
}

// Function to print help with the available commands
func help() {
    print "ls: list files"
    print "cat: open file"
    print "echo: print input"
    print "clear: clear screen"
    print "fibonacci: print fibonacci series"
    print "prime: check if number is prime"
    print "sort: sort numbers"
    print "help: print help"
    print "sum: sum numbers"
    print "add: add numbers"
    print "helloworld: print helloworld"
    print "factorial: calculate factorial"
}
