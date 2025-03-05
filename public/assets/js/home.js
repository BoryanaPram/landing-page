function contactFormHandler() {
    return {
        formData: {
            name: "", email: "", subject: "", message: "",
        },
        submitForm() {
            fetch('/contact-form-submit.php', {
                method: 'POST', headers: {
                    "Content-Type": "application/json", Accept: "application/json"
                },
                body: JSON.stringify(this.formData)
            }).then(res => {
                if (!res.ok) {
                    throw res.json()
                }
                console.log($event);
                return res.json()
            }).then(res => {
                showSuccessModal(res.message)
            }).catch(res => {
                try {
                    return res.then(r => {
                        showErrorModal(r.message)
                    })
                } catch (error) {
                    showErrorModal(error)
                }
            })
        },
    };
}

function showErrorModal(message) {
    alert(message)
}

function showSuccessModal(message) {
    alert(message)
}
