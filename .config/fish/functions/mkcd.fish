function mkcd
    if [ (count $argv) != 1 ]
        echo "Usage: mkcd DIR"
        return 1
    end

    mkdir -p $argv[1]
    cd $argv[1]
end
