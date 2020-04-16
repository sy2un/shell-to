

### Implementation of another way of shell command cd
##  use


function to(){

	if [ $1 ] || [ $2 ]; then 
		dir=$1		#target move path or Depth of movement
		orientation=$2	
		if [ ! $orientation ]; 
		then
			orientation=0	#default orientation right -> left		
		fi

		if [ $orientation -ne 0 ] && [ $orientation -ne -1 ];
		then
			echo "second arg must be 0 or -1"
			exit 0
		fi
		expr $dir + 6 &>/dev/null
		result=$?

		runDir=$(pwd)
		paths=(${runDir//// })
		let countPath=${#paths[*]}
		unset paths[$countPath]
		echo ${paths[*]}

		path=""
		if [ $result -eq 0 ]; then
			if [ $orientation == -1 ]; then
				let dir=countPath-dir
			fi

			for i in $(seq 1 $dir)
			do
				path=$path"../"
			done
			cd $path
		else
			begin=0
			end=$countPath
			incremental=1
			if [ $orientation == 0 ]; then
				let begin=countPath-2
				incremental=-1
				end=0
			fi
			index=0
			findFlag=false
			for i in $(seq $begin $incremental $end)
			do  
				let index++
				if [[ ${paths[$i]} == $dir ]]; then 
					echo "找到 $countPath"
					findFlag=true
					break 1
				fi
			done

			if [ "$findFlag" = true ]; then
				if [ $orientation == 0 ]; then			
					let countPath=index
				else
					let countPath=countPath-index
				fi
				for i in $(seq 1 $countPath)
				do	
					path=$path"../"
				done
				echo "$path"
				cd $path
			else
				echo "cd: $dir: No such file or directory"
			fi
		fi
	else
		echo $(pwd)
	fi

}

