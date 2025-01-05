#!/usr/bin/env python3

import os
import subprocess
import json
from pathlib import Path
from typing import List


def find_test_classes(directory: str) -> List[str]:
    test_classes = []
    for file in Path(directory).glob("*.cls"):
        with open(file, "r") as f:
            content = f.read()
            if "@IsTest" in content or "testMethod" in content:
                class_name = file.stem
                test_classes.append(class_name)
    return test_classes


def parse_test_failures(output: str) -> List[dict]:
    failures = []

    # Try parsing as JSON first
    try:
        test_results = json.loads(output)
        return [
            test
            for test in test_results["result"]["tests"]
            if test["Outcome"] != "Pass"
        ]
    except (json.JSONDecodeError, KeyError):
        # If not JSON, parse the raw output
        lines = output.split("\n")
        current_failure = {}

        for line in lines:
            if "FAIL" in line:
                if "Method Name" in line:
                    if current_failure:
                        failures.append(current_failure)
                    current_failure = {
                        "FullName": line.split("Method Name:")[1].strip()
                    }
                elif "Error Message" in line:
                    current_failure["Message"] = line.split("Error Message:")[1].strip()
                elif "Stack Trace" in line:
                    current_failure["StackTrace"] = line.split("Stack Trace:")[
                        1
                    ].strip()

        if current_failure:
            failures.append(current_failure)

    return failures


def run_apex_tests(test_classes: List[str]) -> None:
    if not test_classes:
        print("No test classes found, you absolute madman!")
        return

    command = ["sf", "apex", "test", "run", "--wait", "60", "--result-format", "json"]
    for test in test_classes:
        command.extend(["--tests", test])

    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        failures = parse_test_failures(result.stdout)

        if not failures:
            print("All tests passed, wubba lubba dub dub!")
            return

        print("\nTest Failures:")
        for failure in failures:
            print(f"\n{failure['FullName']}:")
            print(f"  Message: {failure.get('Message', 'No error message provided')}")
            if failure.get("StackTrace"):
                print(f"  Stack Trace: {failure['StackTrace']}")

    except subprocess.CalledProcessError as e:
        failures = parse_test_failures(e.stdout)
        if failures:
            print("\nTest Failures:")
            for failure in failures:
                print(f"\n{failure['FullName']}:")
                print(
                    f"  Message: {failure.get('Message', 'No error message provided')}"
                )
                if failure.get("StackTrace"):
                    print(f"  Stack Trace: {failure['StackTrace']}")
        else:
            print(f"Tests failed catastrophically:\n{e.stderr}")


def main() -> None:
    apex_dir = "force-app/main/default/classes"
    test_classes = find_test_classes(apex_dir)
    run_apex_tests(test_classes)


if __name__ == "__main__":
    main()
