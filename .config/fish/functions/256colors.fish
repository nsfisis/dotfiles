function 256colors
    for code in (seq 0 255)
        echo -e '\e[38;05;'$code'm '(printf '%3d' $code)': Test'
    end
end
