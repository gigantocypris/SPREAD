for subdir in `seq -w 029 047` `seq -w 049 055`; do
        sbatch step1.sh $subdir params_1.phil
done

for subdir in 069 070 `seq -w 074 085` `seq -w 087 108` `seq 121 139` 147 148 `seq 151 154` `seq 163 167` 169 172 173 `seq 175 182` `seq 187 188` `seq 195 205` `seq 210 214` `seq 226 230` `seq 238 240` `seq 244 256`; do
        sbatch step1.sh $subdir params_1_69plus.phil
done