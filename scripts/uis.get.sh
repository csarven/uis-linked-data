#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./uis.config.sh

rm "$data""$agency".prov.retrieval.rdf

echo '<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:sdmx="http://purl.org/linked-data/sdmx#">' > "$data""$agency".prov.retrieval.rdf ;

sed -i 's/\&ndash;/\&#8211;/g' uis.html
xmllint --xpath "/ul/li/ul/li/ul/li/a[@class = \"ds\"]" uis.html | sed 's/\/a>/\/a>\n/gi' > uis.temp

Get=(Data DataStructure);

counter=1;
while read i ;
    do
        DataSetCode=$(echo "$i" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)/$2/');

        for GD in "${Get[@]}" ;
            do
                echo "$counter $DataSetCode $GD" ;

                if [ "$GD" == "Data" ]
                then
                    DataType="http:\/\/purl.org\/linked-data\/sdmx#DataSet"
                    DataTypeLabel="Data"
                    DataTypePath=""
                else
                    DataType="http:\/\/purl.org\/linked-data\/sdmx#DataStructureDefinition"
                    DataTypeLabel="Structure"
                    DataTypePath=".Structure"
                fi
        sleep 1
                dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
                dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;
#        wget -c -t 1 --no-http-keep-alive "http://data.uis.unesco.org/restsdmx/sdmx.ashx/Get$GD/$DataSetCode" -O "$data""$DataSetCode""$DataTypePath".xml
        sleep 1
                dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
                dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

                echo "$i" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)<\/a>/
                <rdf:Description rdf:about="http:\/\/uis.270a.info\/provenance\/activity\/'$dtstartd'">
                    <rdf:type rdf:resource="http:\/\/www.w3.org\/ns\/prov#Activity"\/>
                    <prov:startedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtstart'<\/prov:startedAtTime>
                    <prov:endedAtTime rdf:datatype="http:\/\/www.w3.org\/2001\/XMLSchema#dateTime">'$dtend'<\/prov:endedAtTime>
                    <prov:wasAssociatedWith rdf:resource="http:\/\/csarven.ca\/#i"\/>
                    <prov:used rdf:resource="https:\/\/launchpad.net\/ubuntu\/+source\/wget"\/>
                    <prov:used>
                        <rdf:Description rdf:about="http:\/\/data.uis.unesco.org\/restsdmx\/sdmx.ashx\/Get'$GD'\/$2">
                            <foaf:page rdf:resource="http:\/\/data.uis.unesco.org\/$4"\/>
                            <dcterms:identifier>'$DataSetCode'<\/dcterms:identifier>
                            <dcterms:title>$5<\/dcterms:title>
                        <\/rdf:Description>
                    <\/prov:used>
                    <prov:generated>
                        <rdf:Description rdf:about="http:\/\/uis.270a.info\/data\/'$DataSetCode''$DataTypePath'.xml">
                            <dcterms:identifier>'$DatasetCode'<\/dcterms:identifier>
                            <dcterms:title>$5<\/dcterms:title>
                        <\/rdf:Description>
                    <\/prov:generated>
                    <rdfs:label xml:lang="en">Retrieved '$DataSetCode' '$DataTypeLabel'<\/rdfs:label>
                    <rdfs:comment xml:lang="en">'$DataTypeLabel' of dataset '$DataSetCode' retrieved from source and saved to local filesystem.<\/rdfs:comment>
                <\/rdf:Description>/' >> "$data""$agency".prov.retrieval.rdf ;

                if [ "$GD" == "Data" ]
                then
                echo "$i" | perl -pe 's/<a(.*)(?=dscode)dscode=\"([^\"]*)\"(.*)(?=href)href=\"([^\"]*)\">([^<]*)<\/a>/
                <rdf:Description rdf:about="http:\/\/uis.270a.info\/dataset\/'$DataSetCode'">
                    <dcterms:title>$5<\/dcterms:title>
                <\/rdf:Description>/' >> "$data""$agency".prov.retrieval.rdf ;
                fi
            done
        (( counter++ ));
    done < uis.temp

echo -e "\n</rdf:RDF>" >> "$data""$agency".prov.retrieval.rdf ;

mv uis.temp /tmp/

#real	1m49.403s
#user	0m0.440s
#sys	0m2.748s

#wget "http://data.uis.unesco.org/restsdmx/sdmx.ashx/GetData/$DataSetCode"
#wget "http://data.uis.unesco.org/restsdmx/sdmx.ashx/GetDataStructure/"$DataSetCode"

#Try GETing empty files again.
#find *.xml -empty | sed 's/.xml//' | while read i ; do wget -t 2 -c "http://data.uis.unesco.org/restsdmx/sdmx.ashx/GetData/$i" -O "$i".xml
