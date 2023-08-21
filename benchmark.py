import argparse
import json
import subprocess

from dataclasses import dataclass
from functools import cache
import sys
from typing import Dict, List

languages_to_run = ""
iterations = 15


@dataclass
class Language:
    proper_name: str
    short_name: str
    run_cmd: str
    enabled: bool

    def __hash__(self):
        return hash(self.proper_name)

    @cache
    def will_run(self):
        if (languages_to_run):
            if (languages_to_run == "all"):
                return True
            elif self.short_name in languages_to_run.split(','):
                return True
            else:
                return False
        else:
            return self.enabled

def language_decoder(language_dict):
    return Language(
        proper_name = language_dict["properName"],
        short_name = language_dict["shortName"],
        run_cmd = language_dict["runCmd"],
        enabled = language_dict["enabled"]
    )

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--iterations", help="Number of benchmark iterations")
    parser.add_argument("-l", "--languages", help="Languages to run, comma separated. (e.g. c,cpp,rust,python)")
    parser.add_argument("-n", "--no-clean", action="store_true", help="Don't cleanup after benchmark")
    parser.add_argument("-b", "--basic", action="store_true", help="Display basic hyperfine output")
    args = parser.parse_args()

    file = open("./benchmark_setup.json", encoding="utf8")
    languages_dict = json.loads(file.read())
    languages = [language_decoder(lang) for lang in languages_dict["languages"]]
    file.close()

    global iterations
    if args.iterations:
        iterations = args.iterations
    
    global languages_to_run
    if args.languages:
        languages_to_run = args.languages

    command: List[str] = ["hyperfine", "--time-unit", "millisecond", "--ignore-failure", "--export-markdown", "benchmark_results.md", "--runs", str(iterations), "-N", "--warmup", "1"]
    main_cmd = []

    for lang in languages:
        if lang.will_run():
            result = subprocess.run(["make", "-C", lang.short_name], check=False)
            if result.returncode != 0:
                print(f"Failed to build {lang.proper_name}", file=sys.stderr)

            main_cmd += ["--command-name", lang.proper_name]
            main_cmd.append(lang.run_cmd)


    command = command + main_cmd
    if args.basic:
        command += ["--style", "basic",]

    subprocess.run(command, check=True)

    if not args.no_clean:
        print("Cleaning up...")
        for lang in languages:
            if lang.will_run():
                subprocess.run(["make", "-C", lang.short_name, "clean"], check=False, capture_output=True)

if __name__ == "__main__":
    main()
