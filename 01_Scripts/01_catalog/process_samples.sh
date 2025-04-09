for i in {01..30}; do
    # Format the sample name as Mxx
    sample="M$(printf "%02d" $i)"
    
    # Process the file
    cat "filtered_coverage_${sample}.txt" | cut -f1,3,4,6,7,9 > "filtered_coverage_${sample}_columns.txt"
done

