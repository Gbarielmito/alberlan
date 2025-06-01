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

// Função para diagnosticar com base nos sintomas
function diagnose(symptoms) {
    const possibleDiseases = [];
    
    // Verifica cada doença na base de conhecimento
    for (const [diseaseKey, disease] of Object.entries(knowledgeBase.diseases)) {
        // Conta quantos sintomas da doença estão presentes
        const matchingSymptoms = disease.symptoms.filter(symptom => 
            symptoms.includes(symptom)
        );
        
        // Se pelo menos 2 sintomas correspondem, considera como possível diagnóstico
        if (matchingSymptoms.length >= 2) {
            possibleDiseases.push({
                name: disease.name,
                description: disease.description,
                matchingSymptoms: matchingSymptoms,
                matchPercentage: (matchingSymptoms.length / disease.symptoms.length) * 100
            });
        }
    }
    
    return possibleDiseases;
}

// Função para exibir os resultados
function displayResults(diseases) {
    const resultDiv = document.getElementById('diagnosisResult');
    
    if (diseases.length === 0) {
        resultDiv.innerHTML = '<p>Nenhum diagnóstico possível com os sintomas selecionados.</p>';
        return;
    }
    
    let html = '<div class="diagnoses">';
    diseases.forEach(disease => {
        html += `
            <div class="diagnosis-item">
                <h3>${disease.name}</h3>
                <p>${disease.description}</p>
                <p>Sintomas correspondentes: ${disease.matchingSymptoms.join(', ')}</p>
                <p>Probabilidade: ${disease.matchPercentage.toFixed(1)}%</p>
            </div>
        `;
    });
    html += '</div>';
    
    resultDiv.innerHTML = html;
}

// Event listener para o botão de diagnóstico
document.getElementById('diagnoseBtn').addEventListener('click', () => {
    const selectedSymptoms = Array.from(document.querySelectorAll('input[name="symptom"]:checked'))
        .map(checkbox => checkbox.value);
    
    if (selectedSymptoms.length === 0) {
        alert('Por favor, selecione pelo menos um sintoma.');
        return;
    }
    
    const possibleDiseases = diagnose(selectedSymptoms);
    displayResults(possibleDiseases);
}); 