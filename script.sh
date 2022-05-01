#script.sh

if [ $# -ne 3 ]; then
    echo "usage: $0 <UTR or lnc> <batch name> <number of samples>"
    exit 1
fi

UTRorLNC=$1
SAMPLENAME="$1-$2"
NUMSAMPLES="$3"
echo $SAMPLENAME " drawing $3 " samples

mkdir $SAMPLENAME-out

#useful for testing purposes so script runs quickly:
#awk '{print $3-$2 " " $4 " " $1 " " $2 " " $3-$2}' $UTRorLNC.bed | sort -n | head -n $NUMSAMPLES | awk '{print $2 " " $3 " " $4 " " $5}' > $SAMPLENAME-shortsample.txt

#actual sampling of the data
awk '{print $4 " " $1 " " $2 " " $3-$2}' $UTRorLNC.bed | shuf | head -n $NUMSAMPLES > $SAMPLENAME-sample.txt

echo "name chromosomes length genome SNPs aligned" > $SAMPLENAME-matchinfo.txt

cat $SAMPLENAME-sample.txt | while read line;
do set $line;
echo -n "$1 $2 $4 " >> $SAMPLENAME-matchinfo.txt;
halSnps --tsv "$SAMPLENAME-out/$2$1.tsv" --start $3 --length $4 241-mammalian-2020v2.hal Homo_sapiens Solenodon_paradoxus >> $SAMPLENAME-matchinfo.txt;
done


awk -v SAMPLENAME=$SAMPLENAME '{totalSNPs+=$5; totalMatches+=$6; totallen+=$3} END{print "\n" SAMPLENAME "\ntotal len:" totallen "\ntotal aligned:" totalMatches "\ntotal non-SNPs:" totalMatches-totalSNPs "\ntotal SNPs:" totalSNPs "\npercent aligned:"totalMatches/totallen "\npercent SNPs of aligned:"totalSNPs/totalMatches "\n"}' $SAMPLENAME-matchinfo.txt > $SAMPLENAME-matchsummary.txt;

cat $SAMPLENAME-matchsummary.txt;

echo "Homo_sapiens Solenodon_paradoxus" > $SAMPLENAME-final_sequences.txt
cat $SAMPLENAME-out/* | grep -v refSequence | tr [:lower:] [:upper:] | awk '{print $3 " " $4}' >> $SAMPLENAME-final_sequences.txt
