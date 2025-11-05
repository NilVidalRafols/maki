# maki
Maki is a simple yet powerful CLI tool for text processing. In its basic form, Maki extends the functionality of the `cat` command by allowing you to concatenate not only files and input from stdin, but also strings and template contents. Additionally, it lets you use concatenated results as system and user prompts for LLM inference. These capabilities are further expanded with support for running operations on multiple files simultaneously using a map-reduce model.

## Usage
Different functionalities can be accessed using maki subcommands. If no subcommand is invoked, maki behaves as a content concatenation tool. You can provide contents in the following ways:
    - File paths.
    - Template names. Using the option `-t` followed by a template name, maki will search for a matching file name (without taking the extension into account) in `$HOME/.maki-templates/`
    - Strings.
    - Stdin content. Add `-` where you want the contents to be placed.

Take the following command as an example:
```
echo "Lorem Ipsum" | maki hello_world.txt -t fox - "foo, bar, baz"
```
It would output the following content:
```
Hello World!
The quick brown fox jumps over the lazy dog
Lorem Ipsum
foo, bar, baz
```
Here, the files `./hello_world.txt` and `~/.maki-templates/fox.txt` have these contents respectively: "Hello World!", "The quick brown fox jumps over the lazy dog".

Maki can also be run using the small command `m`.

### LLM
This subcommand requires the *llm* CLI tool to be installed on your system. You can find out more about it in its [GitHub page](https://github.com/simonw/llm). This subcommand allows you to construct a prompt that will be passed to an llm. This time, the output of the command will be the llm response. This command introduces the following concepts.
    - To define the user prompt, you can do it as if you were using the default maki command. However, you can also define a system command by prepending each argument with the option `-s` (`-st` for templates!).
    - Additionally, you can pass some configuration to the llm CLI tool:
        - `-m`. Specify the llm model to be used.
        - `--no-stream`. Disable output streaming.

It is recommended to read some documentation related to the configuration of the llm CLI tool for at least the parameters that are directly set with maki!

This would be an example:
```
echo "Lorem Ipsum" | maki llm -st brief -s "Repeat the contents provided by the user" hello_world.txt -t fox - "foo, bar, baz"
```
With the following output:
```
Hello World!
The quick brown fox jumps over the lazy dog
Lorem Ipsum
foo, bar, baz
```
The additional file `~/.maki-templates/brief.txt` contains the following text: "Only provide the answer, no extra explanation or apology."  

Maki llm can also be run directly using the small command `mllm`.

### MAP
This subcommand allows you to apply any bash expression to the contents of all provided files, and then stores the output of each execution in a different file inside the specified output directory.

Here is an example:
```
maki map 'maki llm -st brief -s "Write a list with all the skills demanded in this job offer" -' /tmp/out /tmp/jobs/*.md
```
This command will create a file containing a skill list for each `.md` file present in `/tmp/jobs/`. Notice the `-` at the end of the maki llm command. It has to be added because file contents are passed through stdin to the bash expression, keep that in mind when defining it! After running the command, you could *reduce* the results by creating a single file with all relevant skills (maybe using an awk script). This would be an example of a proper map-reduce operation using maki.

The map subcommand can be used in workflows where there are large amounts of data or text to be analysed. Then, concrete pieces of that data can be passed to maki map to obtain insight. This can help maintain reliability when the amount of text is too big or a lightweight model is used.

Maki map can also be run directly using the small command `mmap`.

### PMAP (Parallel Map)
PMAP is functionally identical to the map subcommand. In this case though, pmap runs all operations in parallel. Depending on the LLM inference service that is being used, it can shorten the time it takes to complete all executions. However, make sure not to get flagged as a DOS attack if you want to map too many files!

Maki pmap can also be run directly using the small command `mpmap`.

## Installation
Running the install script will install the maki and subcommand executables at $HOME/.local/bin/.
```
curl -fsSL https://raw.githubusercontent.com/NilVidalRafols/maki/main/install.sh | bash
```

You can also review or modify the installation process by saving the install script first.
```
curl -fsSL https://raw.githubusercontent.com/NilVidalRafols/maki/main/install.sh -o install.sh
bash install.sh
```

To uninstall Maki, follow the same approach using the `uninstall.sh` script.
