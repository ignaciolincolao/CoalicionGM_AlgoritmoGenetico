#!/bin/bash
m=(56)
pTresh=(0.15)
pr=(0.2)

vot=points_36_1689098032
cd out/

mkdir -p "Resultados/$vot"
#para windows
#cd build/x64-release
#para linux
cd build/linux-Release/
let seed=1234
let iter=1

for repeat in {1..1000}
do 
    for m_val in "${m[@]}"
    do
        mkdir -p "../../Resultados/$vot/m_$m_val"
        for pTresh_val in "${pTresh[@]}"
        do
            mkdir -p "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val"
            for pr_val in "${pr[@]}"
            do
                mkdir -p "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val"
                echo "---------######## $iter/1000 ######----------"
                ((seed+=$repeat*2))
                #para windows
                ./algortimoc++ $m_val $pTresh_val $pr_val $seed $vot || echo "---------######## error en:  m = $m_val, pTresh = $pTresh_val, pr = $pr_val, seed= $seed donde $repeat de 5 ######----------"
                #para linux
                #./algortimoc++ $m_val $pTresh_val $pr_val $seed || cat "$seed.txt" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/histograma_m_${m_val}_pTresh_${pTresh_val}_pr_" "${seed}.txt" 
                cp resultados.json "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json" 
                cp hist.json "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/histograma_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json" 
                rm resultados.json
                rm hist.json
                ((iter+=1))
            done
        done
        
    done
done
echo "---------######## Completado hay que deletear los archivos de hist y resultados ######----------"

for repeat in {1..1000}
do 
    for m_val in "${m[@]}"
    do
        for pTresh_val in "${pTresh[@]}"
        do
            for pr_val in "${pr[@]}"
            do
                echo "---------######## $iter/1000 ######----------"
                mdos=$(jq ".sample_size" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json") 
                pt=$(jq ".mutation_threshold" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json") 
                p=$(jq ".selection_threshold" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json") 
                seed=$(jq ".seed" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json") 
                ite=$(jq ".number_of_iteration" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json")
                arrv=$(jq ".arrive" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json")  
                fit=$(jq ".fitness" "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/resultados_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json")

                echo "$mdos, $pt, $p, $seed, $ite, $arrv,$fit" >>  prueba_adhoc_not_best_$vot.csv
                #cp hist.json "../../Resultados/$vot/m_$m_val/pTresh_$pTresh_val/pr_$pr_val/histograma_rep_${repeat}_m_${m_val}_pTresh_${pTresh_val}_pr_${pr_val}.json" 
                ((iter+=1))
            done
        done
        
    done
done