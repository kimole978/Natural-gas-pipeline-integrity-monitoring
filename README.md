# Natural Gas Pipeline Integrity Monitoring

A blockchain-based energy infrastructure platform for tracking pipeline inspections, corrosion monitoring, leak detection, and safety compliance.

## Overview

The Natural Gas Pipeline Integrity Monitoring system is a smart contract solution built on the Stacks blockchain using Clarity. It provides a decentralized platform for managing pipeline safety operations, including:

- **Pipeline Condition Monitoring**: Track inspections, corrosion rates, and structural integrity
- **Corrosion Detection**: Monitor cathodic protection systems and coating condition
- **Leak Detection**: Identify and track gas leaks with location and severity
- **Inspection Scheduling**: Automate compliance-driven inspection cycles
- **Regulatory Compliance**: Ensure adherence to PHMSA and state regulations

## Features

### Pipeline Management
- Register pipeline segments with specifications and location data
- Track operating pressure, age, and material composition
- Monitor inline inspection (ILI) tool results
- Assess risk factors and consequence ratings
- Maintain comprehensive asset inventory

### Corrosion Monitoring
- Record cathodic protection survey readings
- Track coating condition assessments
- Monitor pipeline-to-soil potential measurements
- Identify high-risk corrosion areas
- Schedule remediation activities

### Leak Detection & Response
- Report and track detected leaks
- Classify leak severity and gas volume
- Coordinate emergency response
- Document repair activities
- Analyze leak patterns for prevention

### Inspection Management
- Schedule mandated inspections based on regulatory cycles
- Record inline inspection findings
- Track smart pig run results
- Document hydrostatic test outcomes
- Maintain inspection history and compliance status

### Regulatory Compliance
- Ensure Pipeline and Hazardous Materials Safety Administration (PHMSA) compliance
- Track 49 CFR Part 192 and 195 requirements
- Generate regulatory reports
- Monitor violation and incident reporting
- Maintain audit-ready documentation

## Smart Contract Architecture

The system is built using a single, comprehensive Clarity smart contract that handles all core functionality without cross-contract calls or trait dependencies.

### Key Data Structures

- **Pipeline Segments Map**: Complete pipeline specifications, location, and status
- **Inspection Records**: Detailed findings from ILI tools and visual assessments
- **Corrosion Data**: CP survey results and corrosion rate measurements
- **Leak Reports**: Active and resolved leak incidents with severity ratings
- **Compliance Status**: Regulatory requirement tracking and violation records

### Core Functions

#### Pipeline Management
- `register-pipeline-segment`: Add new pipeline sections to monitoring system
- `update-pipeline-condition`: Record condition changes from assessments
- `calculate-risk-score`: Determine integrity risk based on multiple factors
- `retire-pipeline-segment`: Remove decommissioned sections

#### Inspection Operations
- `schedule-inspection`: Create inspection requirements
- `record-inspection-results`: Document findings from ILI tools
- `approve-inspection`: Mark inspection as satisfactory
- `flag-inspection-concern`: Identify critical findings requiring action

#### Corrosion Monitoring
- `record-cp-survey`: Log cathodic protection measurements
- `update-corrosion-rate`: Track metal loss over time
- `schedule-coating-repair`: Plan remediation activities
- `assess-corrosion-risk`: Calculate corrosion threat levels

#### Leak Management
- `report-leak`: Document detected gas leak
- `classify-leak-severity`: Assign priority level
- `complete-leak-repair`: Close out repair activities
- `analyze-leak-trends`: Identify systemic issues

#### Query Functions
- `get-pipeline-info`: Retrieve segment details
- `get-inspection-record`: Access inspection findings
- `get-corrosion-data`: View CP survey results
- `get-leak-report`: Check leak incident details
- `calculate-compliance-status`: Determine regulatory standing

## Technical Specifications

- **Blockchain**: Stacks
- **Smart Contract Language**: Clarity
- **Contract Size**: 150+ lines of production code
- **Data Integrity**: Immutable safety records for regulatory audit
- **Access Control**: Role-based permissions for operators and inspectors

## Use Cases

### Pipeline Operators
- Comprehensive integrity management program
- Regulatory compliance tracking
- Risk-based maintenance prioritization
- Safety incident documentation

### Inspection Companies
- Standardized reporting format
- ILI tool result verification
- Quality assurance tracking
- Client transparency

### Regulatory Agencies
- Real-time compliance monitoring
- Incident investigation records
- Operator performance assessment
- Public safety oversight

### Insurance Providers
- Risk assessment data
- Claims investigation support
- Premium calculation inputs
- Loss prevention insights

## Security Features

- Principal-based authentication for safety-critical operations
- Immutable audit trail for regulatory investigations
- Input validation for all measurement data
- Protection against unauthorized modifications
- Emergency response coordination
- Incident notification requirements

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for deployment
- Node.js for testing framework
- Understanding of pipeline integrity management

### Installation

```bash
git clone https://github.com/[username]/Natural-gas-pipeline-integrity-monitoring.git
cd Natural-gas-pipeline-integrity-monitoring
npm install
clarinet check
clarinet test
```

### Deployment

```bash
clarinet deploy --testnet
clarinet deploy --mainnet
```

## Testing

The contract includes comprehensive unit tests covering:
- Pipeline segment registration and updates
- Inspection workflow and findings documentation
- Corrosion monitoring and risk calculation
- Leak detection and response tracking
- Compliance status verification

## Regulatory References

- PHMSA 49 CFR Part 192 (Natural Gas Pipeline Safety)
- PHMSA 49 CFR Part 195 (Liquid Pipeline Safety)
- ASME B31.8 (Gas Transmission and Distribution Piping Systems)
- NACE SP0169 (Cathodic Protection Standards)
- API 1160 (Pipeline Integrity Management)

## Development Workflow

1. Main branch contains stable releases and documentation
2. Development branch for active contract development
3. Feature branches for specific enhancements
4. Pull requests required for merging to main

## Future Enhancements

- IoT sensor integration for real-time monitoring
- Predictive analytics for failure prevention
- GIS mapping integration
- Automated SCADA system data feeds
- Machine learning corrosion rate prediction
- Mobile inspection apps integration

## Contributing

Contributions are welcome! Please follow the standard fork-and-pull request workflow.

## License

MIT License - see LICENSE file for details

## Contact

For questions or support, please open an issue on the GitHub repository.

## Acknowledgments

Built on the Stacks blockchain using Clarity smart contract language, providing transparent and immutable records for critical energy infrastructure safety management.
