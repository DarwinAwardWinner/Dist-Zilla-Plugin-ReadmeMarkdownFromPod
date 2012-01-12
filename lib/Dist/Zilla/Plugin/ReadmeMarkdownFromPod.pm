use strict;

package Dist::Zilla::Plugin::ReadmeMarkdownFromPod;

# ABSTRACT: Automatically convert POD to a README.mkdn for Dist::Zilla

use Moose;
extends 'Dist::Zilla::Plugin::ReadmeAnyFromPod';

use Dist::Zilla::Plugin::ReadmeAnyFromPod;

my $config_override = {
    type => 'markdown',
    filename => $Dist::Zilla::Plugin::ReadmeAnyFromPod::_types->{markdown}->{filename},
    location => 'build',
};

# Override the return values of all the accessors to always return the
# markdown defaults
for my $method_name (keys %$config_override) {
    around $method_name => sub { return $config_override->{$method_name}; }
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

    # dist.ini
    [ReadmeMarkdownFromPod]

=head1 DESCRIPTION

Generate a README.mkdn from C<main_module> by L<Pod::Markdown>

The code is mostly a copy-paste of L<Dist::Zilla::Plugin::ReadmeFromPod>
