# Scholarly Impact Network

A decentralized platform for tracking and rewarding academic impact built on blockchain technology.

## Overview

The Scholarly Impact Network is a smart contract system designed to create transparency and incentives in academic publishing and citation networks. It enables scholars to register their publications, record references between works, track impact metrics, and earn recognition for their scholarly contributions.

## Key Features

* **Publication Registration**: Scholars can register their publications with metadata including title, discipline, and summary.
* **Reference Tracking**: Record and verify references between scholarly works with weighted significance values.
* **Impact Metrics**: Track citation counts, scholar h-indices, and discipline-specific impact metrics.
* **Validation System**: Publications can be validated by authorized validators to add credibility.
* **Recognition System**: Scholars earn recognition points when their works are referenced, creating incentives for quality research.

## Smart Contract Functions

### Core Functions

- `register-publication`: Register a new scholarly publication
- `add-reference`: Add a reference from one publication to another
- `validate-publication`: Validate the authenticity of a publication (validators only)
- `add-validator`: Add a new validator (admin only)
- `remove-validator`: Remove an existing validator (admin only)
- `claim-recognition`: Claim accumulated recognition rewards

### Read-Only Functions

- `get-publication-details`: Retrieve details about a specific publication
- `get-reference-details`: Get details about a specific reference between publications
- `get-reference-count`: Get the number of references for a publication
- `get-scholar-profile`: Get metrics about a scholar's publications and impact
- `get-discipline-metrics`: View impact metrics for a specific academic discipline
- `get-recognition-points`: Check recognition points earned by a scholar
- `get-scholar-h-index`: Calculate an approximation of a scholar's h-index
- `is-validator`: Check if a given principal is an approved validator

## Use Cases

- **Academic Institutions**: Track faculty research impact without relying on proprietary metrics
- **Individual Scholars**: Build verifiable research portfolios and track recognition
- **Research Funders**: Measure impact of funded research
- **Publishers**: Integrate with traditional publishing workflows for transparent citation metrics
- **Open Science**: Support transparent, decentralized mechanisms for scholarly communication

## Getting Started

### Prerequisites

- Clarity development environment
- Understanding of blockchain concepts
- Stacks blockchain wallet

### Deployment

1. Clone this repository
2. Deploy the contract to the Stacks blockchain
3. Interact with the contract using the Stacks API

## Future Development

- Integration with digital identifiers (DOI, ORCID)
- Tokenized rewards for highly cited publications
- Expanded validation mechanisms for peer review
- Visualization tools for citation networks
- Integration with existing academic databases


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.