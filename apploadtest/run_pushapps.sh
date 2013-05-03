export RESULTSFILE=$TMPDIR/cfpushapps/results.txt

rm -f $RESULTSFILE

export APPDIR=../apps/sinatra-benchmark

if [ -z "$DOMAIN" ]; then
	echo "Please set the DOMAIN environment variable to the root url for your Cloud Foundry deployment"
	exit 1
fi

if [ -z "$ADMINPWD" ]; then
	echo "Please set the ADMINPWD environment variable for your cloud administrator password"
	exit 1
fi

echo "Shoving apps down the pipeline. Writing results to $RESULTSFILE"

for runner in a b c d e f g h i j k l m n o p q r s t; do
  export HOME=$TMPDIR/cfpushapps/$runner
  mkdir -p $HOME
  export RUNNER=$runner
  echo "...kicking off runner $runner"
  rspec pushapps_spec.rb >> $RESULTSFILE &
done
