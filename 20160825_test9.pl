#!/usr/bin/perl

#use strict;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;
my $reg = "Bio::EnsEMBL::Registry";

print "Connect to DB\n";
$reg->load_registry_from_db(
    -host , "ensembldb.ensembl.org",
    -user , "anonymous"
);

my $comparadb= new Bio::EnsEMBL::Compara::DBSQL::DBAdaptor(
    -host   => "ensembldb.ensembl.org",
    -port   => 5306,
    -user   => "anonymous",
    -dbname => 'ensembl_compara_51',
);

print "Get Adaptors\n"; #(Species, Type of DB, Type of Object)
my $hg_adaptor = $reg->get_adaptor("human","core","Gene"); #what adaptors do I need to get to homology
my $familyA = $reg->get_adaptor("Multi", "compara", "Family");
my $seqmemberA = $reg->get_adaptor("Multi", "compara", "SeqMember");


my $gene_member_adaptor = Bio::EnsEMBL::Registry->get_adaptor('Multi', 'compara', 'GeneMember');
my $gene_member = $gene_member_adaptor->fetch_by_stable_id('ENSG00000196218');

my $homology_adaptor = Bio::EnsEMBL::Registry->get_adaptor('Multi', 'compara', 'Homology');
my $homologies = $homology_adaptor->fetch_all_by_Member($gene_member);

my $n = 0;

foreach my $homology (@{$homologies}) {
	#if($homology->description eq 'within_species_paralog'){
		print $n," ", $homology->description," ", $homology->taxonomy_level,"\n";	
		$n = $n + 1;
		my $homology2 = $homologies->[$n];
		print 'test ' %{$homology2};

		foreach my $member (@{$homology2->get_all_Members}) {
				if ($member->taxon_id == 9606) {
					print (join " ", map { $member->$_ } qw(stable_id));
					print " ";
					print $member->taxon_id;
					print "\n";
					#print (join " ", map { $member->$_ } qw(perc_id perc_pos perc_cov));
					#print "\n";
				}
		}
	#}
	#print " dn ", $homology->dn,"\n";
  	#print " ds ", $homology->ds,"\n";
	#print " dnds_ratio ", $homology->dnds_ratio,"\n";
}

#my $homology = $homologies->[0];
#print ref($homologies);
#print ref($homology);
#foreach my $member (@{$homology->get_all_Members}) {
#	print ref($member) . "\n";
#	print (join " ", map { $member->$_ } qw(stable_id taxon_id));
#	print "\n";
#	print (join " ", map { $member->$_ } qw(perc_id perc_pos perc_cov));
#	print "\n";
#}
	
#my $this_family = $familyA->fetch_by_stable_id('ENSFM00300000084926');
#print $fam;