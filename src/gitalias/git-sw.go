package main

import (
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	gitArgs := []string{"switch"}
	if requiresDetachFlag(os.Args) {
		gitArgs = append(gitArgs, "--detach")
	}
	for i, argv := range os.Args {
		if i == 0 {
			continue // argv[0] is a program name.
		}
		gitArgs = append(gitArgs, argv)
	}

	cmd := exec.Command("git", gitArgs...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		switch err.(type) {
		case *exec.ExitError:
			// Do nothing here because Git has already reported the error.
		default:
			log.Fatal(err)
		}
	}

	os.Exit(cmd.ProcessState.ExitCode())
}

func requiresDetachFlag(argv []string) bool {
	argc := len(argv)
	if argc == 1 {
		return false
	}
	firstArg := argv[1]
	return strings.HasPrefix(firstArg, "origin/") || strings.HasPrefix(firstArg, "upstream/")
}
