// Base de conhecimento
const knowledgeBase = {
    diseases: {
        gripe: {
            name: "Gripe",
            symptoms: ["febre", "tosse", "dor_corpo", "dor_cabeca"],
            description: "Infecção viral que afeta o sistema respiratório"
        },
        resfriado: {
            name: "Resfriado",
            symptoms: ["coriza", "espirros", "dor_cabeca"],
            description: "Infecção viral leve do trato respiratório superior"
        },
        covid19: {
            name: "COVID-19",
            symptoms: ["febre", "tosse", "falta_ar", "dor_corpo"],
            description: "Doença infecciosa causada pelo coronavírus SARS-CoV-2"
        },
        alergia: {
            name: "Alergia",
            symptoms: ["espirros", "coriza", "coceira"],
            description: "Reação do sistema imunológico a substâncias alérgenas"
        }
    }
};

// Função validar sintomas
const validateSymptoms = (symptoms) => {
    if (symptoms.length === 0) {
        throw new Error('Por favor, selecione pelo menos um sintoma.');
    }
    return symptoms;
};

// Função para calcular a correspondência de sintomas
const calculateSymptomMatch = (diseaseSymptoms, selectedSymptoms) => {
    const matchingSymptoms = diseaseSymptoms.filter(symptom => 
        selectedSymptoms.includes(symptom)
    );
    
    return {
        matchingSymptoms,
        matchPercentage: (matchingSymptoms.length / diseaseSymptoms.length) * 100
    };
};

// Função para diagnosticar com base nos sintomas
const diagnose = (symptoms) => {
    return Object.entries(knowledgeBase.diseases)
        .map(([_, disease]) => {
            const { matchingSymptoms, matchPercentage } = calculateSymptomMatch(disease.symptoms, symptoms);
            
            return matchingSymptoms.length >= 2 ? {
                name: disease.name,
                description: disease.description,
                matchingSymptoms,
                matchPercentage
            } : null;
        })
        .filter(Boolean);
};

// Função para criar o HTML de um diagnóstico individual
const createDiagnosisHTML = (disease) => `
    <div class="diagnosis-item">
        <h3>${disease.name}</h3>
        <p>${disease.description}</p>
        <p>Sintomas correspondentes: ${disease.matchingSymptoms.join(', ')}</p>
        <p>Probabilidade: ${disease.matchPercentage.toFixed(1)}%</p>
    </div>
`;

// Função para exibir os resultados
const displayResults = (diseases) => {
    const resultDiv = document.getElementById('diagnosisResult');
    
    if (diseases.length === 0) {
        resultDiv.innerHTML = '<p>Nenhum diagnóstico possível com os sintomas selecionados.</p>';
        return;
    }
    
    resultDiv.innerHTML = `
        <div class="diagnoses">
            ${diseases.map(createDiagnosisHTML).join('')}
        </div>
    `;
};

// Event listener para o botão de diagnóstico
document.getElementById('diagnoseBtn').addEventListener('click', () => {
    try {
        const selectedSymptoms = Array.from(document.querySelectorAll('input[name="symptom"]:checked'))
            .map(checkbox => checkbox.value);
        
        validateSymptoms(selectedSymptoms);
        const possibleDiseases = diagnose(selectedSymptoms);
        displayResults(possibleDiseases);
    } catch (error) {
        alert(error.message);
    }
}); 