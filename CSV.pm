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

# Vertex callback.
sub _vertex_callback {
	my ($self, $graph, $id, $vertex_label) = @_;
	if (! exists $self->{'_csv'}) {
		$self->{'_csv'} = Text::CSV->new({'binary' => 1});
	}
	my $status = $self->{'_csv'}->parse($vertex_label);
	if (! $status) {
		err 'Cannot parse label.',
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
