
for subdir in `seq -w 088 091` `seq -w 093 101` `seq -w 103 105` `seq -w 121 125` `seq -w 127 129` `seq -w 134 139` `seq -w 163 167` 169 172 173 `seq -w 175 180` 182 `seq -w 200 205` 211 212 214 228 230 238 239 245 246 247 250 253 256; do
        sbatch step1.sh $subdir params_1.phil
done