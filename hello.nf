process hello {
    output:
    path 'hello.txt'

    script:
    """
    echo 'Hello, World!' > hello.txt
    """
}

workflow {
    hello()
}

