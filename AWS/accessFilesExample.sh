ssh -p 22 rdockma@sblab-wks06.enprc.emory.edu
cd /yerkes-cifs/runs/analyst/rachel
mkdir probeAlign; cd probeAlign
export AWS_DEFAULT_PROFILE="Administrator-_________"
aws sso login # follow prompts

# list files that you want
aws s3 ls --recursive s3://yerkes-gencore-fastq-archive/2022_runs/220912_A00945_0263_BH57GCDSX5/H57GCDSX5/outs/fastq_path/p22229_Amanda-220912B/ \
| grep Capture-24 | grep _R[[:digit:]] | gawk '$4 !~ "/$"{print $4}' > files.lst

# use file list to restore desired objects
for bkey in $(cat files.lst); do
if aws s3api head-object \
	--bucket yerkes-gencore-fastq-archive \
	--key ${bkey} \
	--output yaml | grep "Storage"; then
	echo "restoring ${bkey}"
	aws s3api restore-object --bucket yerkes-gencore-fastq-archive --key ${bkey} --restore-request '{"Days":28}' | cat
	fi
done

# check status of restoration
for bkey in $(cat files.lst); do
echo "${bkey}"
aws s3api head-object \
--bucket yerkes-gencore-fastq-archive \
--key ${bkey} \
--output yaml | grep "ongoing-request"
done

# transfer restored objects
for bkey in $(cat files.lst); do
fullKey="s3://yerkes-gencore-fastq-archive/${bkey}"
echo "${fullKey}"
aws s3 cp ${fullKey} .
done
