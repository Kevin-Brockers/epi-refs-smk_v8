def load_sample_manifest(path):

    samples = pd.read_csv(path,
        sep='\t',
        dtype='str'
    )

    samples['sample_id'] = samples['Target'] \
                          + '_' + samples['Condition'] \
                          + '_rep_' + samples['Replicate'] \
                          + '_geoid_' + samples['GEO_ID'] 

    samples['sample_id_mean'] = samples['Target'] \
                          + '_' + samples['Condition'] \
                          + '_geoid_' + samples['GEO_ID'] 

    samples.astype(dict(
            SRA_ID = 'str',
            GEO_ID = 'str',
            Target = 'category',
            Condition = 'category',
            Experiment = 'category',
            Replicate = 'category',
            Control = 'category',
            Pairing = 'category',
            Sequencer = 'category',
            Peak_type = 'category',
            sample_id = 'category',
            sample_id_mean = 'category'
        ))

    return samples


# def aggregate_duplicates(sample_manifest = ''): 
# # Also create an aggregated datagrame
#     _sample_manifest = sample_manifest.copy()
#     samples = _sample_manifest[['Target', 
#                                 'Condition', 
#                                 'Experiment', 
#                                 'GEO_ID']]

#     samples = samples.astype('str')
#     samples['sample_id'] = samples['Target'] \
#                           + '_' + samples['Condition'] \
#                           + '_geoid_' + samples['GEO_ID']

#     samples = samples.astype('category')
#     samples = samples.drop_duplicates()

#     return samples

def get_treatment_samples(sample_manifest = ''):
    treatment_sample_manifest = sample_manifest[sample_manifest['Control'].notna()]
    return treatment_sample_manifest

# Load sample manifests
SAMPLES_COMPLETE = load_sample_manifest(SAMPLE_MANIFEST_PATH)
SAMPLES_TREATMENT = get_treatment_samples(sample_manifest=SAMPLES_COMPLETE)
# SAMPLES_MEANS = aggregate_duplicates(sample_manifest=SAMPLES_COMPLETE)