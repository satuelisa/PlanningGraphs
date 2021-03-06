timeout=120
find . -size  0 -print0 | xargs -0 rm -- # clean up empty files
if ! test -f 'attempts_${timeout}.lst'; then
    touch attempts_${timeout}.lst
fi
for f in `ls -1 /Users/elisa/Dropbox/Research/Topics/Planning/local/solved/graph/*.graph`;
do
    g=`basename $f .graph`
    echo 'attempting to process' $g
    if test -f "$g.stats"; then
        echo $g 'already processed'
    else
        if grep -Fxq "$g" attempts_${timeout}.lst
        then
            echo $g 'does not finish within the current timeout'
        else
            echo 'processing' $g 'for' $timeout's max'
            gtimeout ${timeout}s python3 layers.py $f > $g.stats
            code=$?
            if [ "$code" -eq "124" ]; then
                echo "interrupted" $g
                rm -f $g.stats
                echo $g >> attempts_${timeout}.lst
	    else
		echo "concluded" $g
            fi
        fi
    fi
done
