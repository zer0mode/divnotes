# git install hub go
> **Use [standalone][0] install or**

## install hub from source
-> [Go][1] programming language needed

#### get a go release
` $ wget https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz `
> find a suitable version on [golang][2] page or on [ubuntu packages][3]

#### extracting archive
- **To custom location**

  *$HOME/gofolder*  
  ` $ cd ~/gofolder `  
  ` $ tar -xzf go$VERSION.$OS-$ARCH.tar.gz `

  add go/bin to ~/.profile

  ```
  export GOROOT=$HOME/gofolder
  export PATH=$PATH:$GOROOT/bin
  ```

>- or through sudo into
>
>  */usr/local*  
>  ` $ tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz `
>  
>  add to PATH
>
>  ` $ export PATH=$PATH:/usr/local/go/bin`

#### cd to hub installation source folder
` $ cd /hub/install/folder `

#### clone hub from source
` $ git clone https://github.com/github/hub.git `  
` $ cd hub `

#### build to a folder visible by PATH
anywhere in ~  
` $ ./script/build -o ~/bin/hub `

*$HOME/bin* is added to $PATH by `~/.profile` so hub should be set to go  
>if you'd prefer to locate the built file elsewhere you can create a symlink  
>` $ sudo ln -s location/to/my/build/hub /usr/local/bin/hub `

#### hub shell auto-completion
The script `hub.bash_completion.sh` is located in **hub/etc** folder. Adding the block below into **~/.bashrc** enables the auto-completion

    if [ -f /path/to/hub.bash_completion ]; then
        . /path/to/hub.bash_completion
    fi

[0]: https://github.com/github/hub
[1]: https://golang.org/doc/
[2]: https://golang.org/dl/
[3]: http://packages.ubuntu.com/golang