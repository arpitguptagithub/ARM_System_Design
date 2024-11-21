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
        print "fibonacci"
        return
    }
    if (buffer == "prime") {
        print "prime"
        return
    }
    if (buffer == "sort") {
        print "sort"
        return
    }
    if (buffer == "help") {
        print "help"
        return
    }
    if (buffer == "sum") {
        print "sum"
        return
    }
    if (buffer == "add") {
        print "add"
        return
    }
    if (buffer == "helloworld") {
        print "helloworld"
        return
    }
    if (buffer == "factorial") {
        print "factorial"
        return
    }
    print "No such file"
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
