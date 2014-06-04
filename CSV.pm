package Graph::Reader::TGF::CSV;

# Pragmas.
use base qw(Graph::Reader::TGF);
use strict;
use warnings;

# Modules.
use Error::Pure qw(err);
use Text::CSV;

# Version.
our $VERSION = 0.01;

# Edge callback.
sub _edge_callback {
	my ($self, $graph, $id1, $id2, $edge_label) = @_;
	my $status = $self->{'_csv'}->parse($edge_label);
	if (! $status) {
		err 'Cannot parse edge label.',
			'Error', $self->{'_csv'}->error_input,
			'String', $edge_label;
		return;
	}
	my %params = map { split m/=/ms, $_ } $self->{'_csv'}->fields;
	foreach my $key (keys %params) {
		$graph->set_edge_attribute($id1, $id2, $key, $params{$key});
	}
	return;
}

# Initialization.
sub _init {
	my ($self, $param_hr) = @_;
	$self->SUPER::_init();
	if (! exists $self->{'_csv'}) {
		$self->{'_csv'} = Text::CSV->new({'binary' => 1});
	}
	return;
}

# Vertex callback.
sub _vertex_callback {
	my ($self, $graph, $id, $vertex_label) = @_;
	my $status = $self->{'_csv'}->parse($vertex_label);
	if (! $status) {
		err 'Cannot parse vertex label.',
			'Error', $self->{'_csv'}->error_input,
			'String', $vertex_label;
		return;
	}
	my %params = map { split m/=/ms, $_ } $self->{'_csv'}->fields;
	foreach my $key (keys %params) {
		$graph->set_vertex_attribute($id, $key, $params{$key});
	}
	return;
}

1;

__END__
