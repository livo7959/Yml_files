# `fivetran-reverse-ssh`

This is a reverse SSH bastion host for use in the [Fivetran](https://www.fivetran.com/) data movement platform, a SaaS product that lives on the internet.

Fivetran needs to access our internal databases. So, in order avoid blowing holes in our company firewall, we can use this container to establish a reverse SSH connection.
