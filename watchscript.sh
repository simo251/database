#!/bin/bash

echo WATCH
date

if [ ! -d rbesolutions ]; then
	mkdir rbesolutions
fi

if OUTPUT=$(rsync -a --info=NAME --exclude 'podcasts' -ur /git/database/* rbesolutions)
then
    if [ "$OUTPUT" != "" ]                   # got output?
    then
		echo OUTPUT $OUTPUT
		
		sleep 2
		
		cd rbesolutions
		rm -r target || true
		mkdir target || true
		
		rm *.lock

		echo start > ~/rbesolutions-bundle-install.log
	
		bundle install --path vendor/cache >> ~/rbesolutions-bundle-install.log
		ruby_path=./vendor/cache/ruby/2.3.0
		
		#GEM_PATH=${GEM_PATH}:${ruby_path} ${ruby_path}/bin/jekyll build -V --destination "target"  >> ~/rbesolutions-jekyll-build.log
		echo GEM_PATH=${GEM_PATH}:${ruby_path} ${ruby_path}/bin/jekyll serve --host=0.0.0.0 > jekyllserve.sh
		
		cd ~/
		
		buildexit=$?
		
		echo exit code "${buildexit}"
		if [ "0" == "${buildexit}" ]; then
			echo OK?
			if [ -f error.log ]; then rm error.log; fi
			sleep 1
		else 
			echo FAIL?
			rm error.log
			cat *.log > error.log
			sleep 1
		fi
	else
		if [ -f error.log ]; then cat error.log; fi
    fi
fi
