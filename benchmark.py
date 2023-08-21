import argparse
import json
import subprocess

from dataclasses import dataclass
from functools import cache
from typing import Dict, List

languages_to_run = ""
iterations = 3

def build_cmd(cmd, env):
    env_string = ""
    for key in env.keys():
        env_string += f"{key}='{env[key]}' "

    return env_string + ' '.join(cmd)


@dataclass
class Language:
    proper_name: str
    short_name: str
    directory: str
    env: Dict
    build_cmds: List[List[str]]
    run_cmd: List[str]
    clean_cmds: List[List[str]]
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

    def get_setup_cmd(self):
        return f"cd {self.directory}; " + "; ".join([build_cmd(cmd, self.env) for cmd in self.build_cmds])

    def get_run_cmd(self):
        
        return f"cd {self.directory}; " + build_cmd(self.run_cmd, self.env)

    def get_clean_cmd(self):
        return f"cd {self.directory}; " + "; ".join([build_cmd(cmd, self.env) for cmd in self.clean_cmds])


def language_decoder(language_dict):
    return Language(
        proper_name = language_dict["properName"],
        short_name = language_dict["shortName"],
        directory = language_dict["dir"],
        env = language_dict["env"],
        build_cmds = language_dict["buildCmds"],
        run_cmd = language_dict["runCmd"],
        clean_cmds = language_dict["cleanCmds"],
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

    command: List[str] = ["hyperfine", "--time-unit", "millisecond", "--ignore-failure", "--export-markdown", "benchmark_results.md", "-N", "--runs", str(iterations), "--warmup", "1"]
    main_cmd = []
    cleanup = []

    for lang in languages:
        if lang.will_run():
            main_cmd += ["--command-name", lang.proper_name]
            if lang.build_cmds:
                main_cmd += ["--prepare", lang.get_setup_cmd()]
            else:
                main_cmd += ["--prepare", "true"]

            main_cmd.append(lang.get_run_cmd())

            if not args.no_clean and lang.clean_cmds:
                cleanup.append(lang.get_clean_cmd())

    command = command + main_cmd + ["--cleanup", "; ".join(cleanup)]
    if args.basic:
        command += ["--style", "basic",]

    subprocess.run(command, check=True)

if __name__ == "__main__":
    main()
