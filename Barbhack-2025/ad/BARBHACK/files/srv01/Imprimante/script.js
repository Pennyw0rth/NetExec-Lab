// Tab switching functionality
function showTab(tabName) {
    // Hide all tab contents
    const tabs = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all nav buttons
    const navBtns = document.querySelectorAll('.nav-btn');
    navBtns.forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(tabName).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Network form handler
function handleNetworkForm(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const networkData = {
        wifiNetwork: document.getElementById('wifi-network').value,
        wifiPassword: document.getElementById('wifi-password').value
    };
    
    // Log captured data (for demonstration - in real scenario, this would be sent to a server)
    console.log('Network Configuration Captured:', networkData);
    
    // Store data locally for demo purposes
    localStorage.setItem('networkConfig', JSON.stringify(networkData));
    
    // Show success message
    showSuccessModal('Network settings updated successfully! Printer will restart in 30 seconds.');
    
    // Reset form
    event.target.reset();
}

// Security form handler
function handleSecurityForm(event) {
    event.preventDefault();
    
    const securityData = {
        adminUsername: document.getElementById('admin-user').value,
        adminPassword: document.getElementById('admin-pass').value,
        domainUsername: document.getElementById('domain-user').value,
        domainPassword: document.getElementById('domain-pass').value,
        timestamp: new Date().toISOString()
    };
    
    // Log captured credentials
    console.log('Security Credentials Captured:', securityData);
    
    // Store data locally for demo purposes
    let storedCredentials = JSON.parse(localStorage.getItem('capturedCredentials') || '[]');
    storedCredentials.push(securityData);
    localStorage.setItem('capturedCredentials', JSON.stringify(storedCredentials));
    
    // Show success message
    showSuccessModal('Security settings applied successfully! Administrative access configured.');
    
    // Reset form
    event.target.reset();
}

// Support form handler
function handleSupportForm(event) {
    event.preventDefault();
    
    const supportData = {
        fullName: document.getElementById('employee-name').value,
        employeeId: document.getElementById('employee-id').value,
        department: document.getElementById('department').value,
        username: document.getElementById('login-username').value,
        password: document.getElementById('login-password').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        ipAddress: 'Client IP would be captured server-side'
    };
    
    // Log captured employee data
    console.log('Employee Data Captured:', supportData);
    
    // Store data locally for demo purposes
    let storedEmployees = JSON.parse(localStorage.getItem('employeeData') || '[]');
    storedEmployees.push(supportData);
    localStorage.setItem('employeeData', JSON.stringify(storedEmployees));
    
    // Show success message
    showSuccessModal('Setup request submitted successfully! IT support will configure your printer access within 24 hours.');
    
    // Reset form
    event.target.reset();
}

// Modal functions
function showSuccessModal(message) {
    document.getElementById('success-message').textContent = message;
    document.getElementById('success-modal').style.display = 'block';
    
    // Auto-close modal after 5 seconds
    setTimeout(() => {
        closeModal();
    }, 5000);
}

function closeModal() {
    document.getElementById('success-modal').style.display = 'none';
}

// Document modal functions with different access scenarios
let currentDocumentName = '';

function showDocumentModal(documentName) {
    currentDocumentName = documentName;
    
    // Determine access type based on document characteristics
    const accessType = determineDocumentAccess(documentName);
    
    document.getElementById('document-name').textContent = documentName;
    document.getElementById('document-modal').style.display = 'block';
    
    const modalContent = document.getElementById('document-modal-content');
    const modalTitle = document.getElementById('modal-title');
    const modalMessage = document.getElementById('modal-message');
    const accessReason = document.getElementById('access-reason');
    const contactInfo = document.getElementById('contact-info');
    const downloadBtn = document.getElementById('download-btn');
    
    // Reset classes
    modalContent.className = 'document-modal-content';
    
    switch(accessType) {
        case 'granted':
            modalContent.classList.add('access-granted');
            modalTitle.innerHTML = '✅ Access Granted';
            modalMessage.textContent = 'Document access authorized - Ready for download';
            accessReason.textContent = 'Valid permissions confirmed';
            contactInfo.textContent = 'Ship\'s Quartermaster for technical issues';
            downloadBtn.style.display = 'inline-block';
            downloadBtn.innerHTML = 'Download';
            downloadBtn.disabled = false;
            break;
            
        case 'denied':
            modalContent.classList.add('access-denied');
            modalTitle.innerHTML = '🚫 Access Denied';
            modalMessage.textContent = 'This document cannot be viewed';
            accessReason.textContent = 'Insufficient permissions or document is in use';
            contactInfo.textContent = 'Ship\'s Captain for access requests';
            downloadBtn.style.display = 'none';
            break;
            
        case 'restricted':
            modalContent.classList.add('access-denied');
            modalTitle.innerHTML = '🔒 Restricted Access';
            modalMessage.textContent = 'This document requires special authorization';
            accessReason.textContent = 'Confidential document - First Mate approval required';
            contactInfo.textContent = 'Captain\'s Cabin or Crow\'s Nest for authorization';
            downloadBtn.style.display = 'none';
            break;
    }
    
    // Log document access attempt
    console.log('Document access attempted:', documentName, 'Access Type:', accessType, 'Time:', new Date().toISOString());
    
    // Store document access attempts
    let accessAttempts = JSON.parse(localStorage.getItem('documentAccessAttempts') || '[]');
    accessAttempts.push({
        document: documentName,
        accessType: accessType,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent
    });
    localStorage.setItem('documentAccessAttempts', JSON.stringify(accessAttempts));
}

// Determine document access based on document name and type
function determineDocumentAccess(documentName) {
    // All documents now return "denied" access
    return 'denied';
}

// Attempt to download document (will always result in 404 for granted documents)
function attemptDownload() {
    const downloadBtn = document.getElementById('download-btn');
    const originalText = downloadBtn.innerHTML;
    
    // Show loading state
    downloadBtn.innerHTML = '<span class="loading-spinner"></span>Downloading...';
    downloadBtn.disabled = true;
    
    // Log download attempt
    console.log('Download attempted for:', currentDocumentName, 'Time:', new Date().toISOString());
    
    // Store download attempts
    let downloadAttempts = JSON.parse(localStorage.getItem('downloadAttempts') || '[]');
    downloadAttempts.push({
        document: currentDocumentName,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        result: '404'
    });
    localStorage.setItem('downloadAttempts', JSON.stringify(downloadAttempts));
    
    // Simulate download attempt that fails with 404
    setTimeout(() => {
        downloadBtn.innerHTML = originalText;
        downloadBtn.disabled = false;
        
        // Change modal to show 404 error
        const modalContent = document.getElementById('document-modal-content');
        const modalTitle = document.getElementById('modal-title');
        const modalMessage = document.getElementById('modal-message');
        const accessReason = document.getElementById('access-reason');
        const contactInfo = document.getElementById('contact-info');
        
        modalContent.className = 'document-modal-content not-found';
        modalTitle.innerHTML = '❌ File Not Found';
        modalMessage.textContent = 'The requested document could not be located';
        accessReason.textContent = 'HTTP 404 - File may have been moved, deleted, or renamed';
        contactInfo.textContent = 'System Administrator for file recovery';
        downloadBtn.style.display = 'none';
        
        console.log('Download failed with 404 for:', currentDocumentName);
    }, 2000 + Math.random() * 3000); // Random delay between 2-5 seconds
}

function closeDocumentModal() {
    document.getElementById('document-modal').style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    const successModal = document.getElementById('success-modal');
    const documentModal = document.getElementById('document-modal');
    
    if (event.target === successModal) {
        closeModal();
    } else if (event.target === documentModal) {
        closeDocumentModal();
    }
}

// Simulate printer status updates
function updatePrinterStatus() {
    const statuses = ['Ready', 'Printing...', 'Processing...', 'Ready'];
    const colors = ['#48bb78', '#3182ce', '#ed8936', '#48bb78'];
    let currentStatus = 0;
    
    setInterval(() => {
        const statusElements = document.querySelectorAll('.status-ready');
        statusElements.forEach(element => {
            element.textContent = statuses[currentStatus];
            element.style.backgroundColor = colors[currentStatus];
        });
        currentStatus = (currentStatus + 1) % statuses.length;
    }, 8000);
}

// Simulate toner level changes
function updateTonerLevel() {
    const levels = ['85%', '82%', '78%', '75%', '72%'];
    let currentLevel = 0;
    
    setInterval(() => {
        const tonerElements = document.querySelectorAll('.status-item span:contains("85%")');
        // This is a simplified approach - in reality, you'd need better element selection
        currentLevel = (currentLevel + 1) % levels.length;
    }, 15000);
}

// Add some fake recent jobs periodically
function addFakeJobs() {
    const jobs = [
        'doc_a7f3k9.pdf',
        'rep_x9w2e4.docx', 
        'pres_g4h7j2.pptx',
        'proj_a1s4d7.docx',
        'fin_i4o7p1.pdf',
        'hr_q7w2e5.pdf'
    ];
    
    setInterval(() => {
        const jobsContainer = document.querySelector('.info-card:nth-child(2)');
        if (jobsContainer) {
            const randomJob = jobs[Math.floor(Math.random() * jobs.length)];
            const jobElement = document.createElement('div');
            jobElement.className = 'job-item';
            jobElement.innerHTML = `
                <span>${randomJob}</span>
                <span class="job-status completed">Completed</span>
            `;
            
            // Add new job at the top
            const existingJobs = jobsContainer.querySelectorAll('.job-item');
            if (existingJobs.length > 0) {
                jobsContainer.insertBefore(jobElement, existingJobs[0]);
            }
            
            // Keep only 5 recent jobs
            const allJobs = jobsContainer.querySelectorAll('.job-item');
            if (allJobs.length > 5) {
                allJobs[allJobs.length - 1].remove();
            }
        }
    }, 20000);
}

// Jobs functionality
let allJobs = [];
let filteredJobs = [];
let currentJobsPage = 1;
let jobsPerPage = 20;

// Generate realistic job data
function generateJobHistory() {
    const documentNames = [
        // Contracts and Legal Documents
        'Contract_2024.pdf', 'Contract_2025.pdf', 'Service_Agreement.pdf', 'NDA_Template.pdf', 'Legal_Agreement.pdf',
        'Partnership_Contract.pdf', 'Employment_Contract.pdf', 'Vendor_Agreement.pdf', 'License_Agreement.pdf', 'Lease_Contract.pdf',
        
        // Reports and Analysis
        'Meeting_Notes.docx', 'Budget_Report.xlsx', 'Financial_Summary.xlsx', 'Sales_Report.xlsx', 'Quarterly_Review.xlsx',
        'Annual_Report.pdf', 'Performance_Metrics.xlsx', 'Revenue_Analysis.xlsx', 'Market_Research.xlsx', 'Cost_Analysis.xlsx',
        'Audit_Report.pdf', 'Risk_Assessment.docx', 'Compliance_Report.pdf', 'Security_Assessment.pdf', 'Quality_Report.pdf',
        
        // Presentations
        'Presentation.pptx', 'Marketing_Proposal.pptx', 'Client_Proposal.pptx', 'Presentation_Slides.pptx', 'Product_Launch.pptx',
        'Strategic_Plan.pptx', 'Team_Building.pptx', 'Growth_Strategy.pptx', 'Company_Overview.pptx', 'Project_Proposal.pptx',
        'Budget_Presentation.pptx', 'Sales_Pitch.pptx', 'Training_Slides.pptx', 'Conference_Presentation.pptx', 'Quarterly_Results.pptx',
        
        // Project Documents
        'Project_Plan.docx', 'Project_Timeline.pdf', 'Technical_Manual.pdf', 'Product_Specs.pdf', 'System_Documentation.pdf',
        'User_Guide.pdf', 'Installation_Manual.pdf', 'Troubleshooting_Guide.pdf', 'API_Documentation.pdf', 'Software_Requirements.pdf',
        'Design_Specifications.pdf', 'Architecture_Document.pdf', 'Test_Plan.docx', 'Implementation_Guide.pdf', 'Deployment_Manual.pdf',
        
        // HR and Administrative
        'Employee_Handbook.pdf', 'HR_Policies.docx', 'Training_Materials.docx', 'Onboarding_Checklist.docx', 'Performance_Review.pdf',
        'Job_Description.docx', 'Interview_Guide.pdf', 'Benefits_Package.pdf', 'Employee_Benefits.docx', 'Vacation_Policy.pdf',
        'Code_of_Conduct.pdf', 'Safety_Manual.pdf', 'Emergency_Procedures.pdf', 'Training_Schedule.xlsx', 'Staff_Directory.docx',
        
        // Financial Documents
        'Invoice_12345.pdf', 'Invoice_12346.pdf', 'Invoice_12347.pdf', 'Expense_Report.xlsx', 'Budget_Forecast.xlsx',
        'Purchase_Order.pdf', 'Receipt_Documentation.pdf', 'Tax_Documents.pdf', 'Financial_Statement.pdf', 'Cash_Flow.xlsx',
        'Payroll_Summary.xlsx', 'Accounting_Records.xlsx', 'Bank_Statement.pdf', 'Credit_Report.pdf', 'Investment_Portfolio.xlsx',
        
        // Marketing and Communications
        'Newsletter.docx', 'Company_Brochure.pdf', 'Brand_Guidelines.pdf', 'Marketing_Campaign.pdf', 'Social_Media_Strategy.docx',
        'Press_Release.docx', 'Customer_Survey.pdf', 'Market_Analysis.xlsx', 'Competitor_Analysis.xlsx', 'Brand_Manual.pdf',
        'Website_Content.docx', 'Blog_Post_Draft.docx', 'Email_Template.docx', 'Advertisement_Copy.docx', 'Campaign_Results.xlsx',
        
        // Operations and Processes
        'Process_Improvement.docx', 'Standard_Operating_Procedure.pdf', 'Workflow_Diagram.pdf', 'Quality_Standards.docx', 'Inventory_Report.xlsx',
        'Supply_Chain_Analysis.xlsx', 'Vendor_Evaluation.xlsx', 'Equipment_Manual.pdf', 'Maintenance_Schedule.xlsx', 'Production_Report.xlsx',
        'Shipping_Instructions.pdf', 'Return_Policy.pdf', 'Customer_Service_Guide.pdf', 'FAQ_Document.docx', 'Support_Manual.pdf',
        
        // Meeting and Event Documents
        'Meeting_Agenda.docx', 'Board_Meeting_Minutes.pdf', 'Conference_Notes.docx', 'Workshop_Materials.pdf', 'Seminar_Handout.pdf',
        'Event_Planning.docx', 'Guest_List.xlsx', 'Catering_Menu.pdf', 'Venue_Contract.pdf', 'Event_Budget.xlsx',
        'Registration_Form.pdf', 'Feedback_Survey.docx', 'Event_Summary.pdf', 'Photo_Release_Form.pdf', 'Equipment_Checklist.xlsx',
        
        // IT and Technical
        'System_Backup.pdf', 'Network_Configuration.pdf', 'Security_Protocol.pdf', 'Password_Policy.pdf', 'IT_Procedures.docx',
        'Software_License.pdf', 'Hardware_Inventory.xlsx', 'Incident_Report.pdf', 'Change_Request.docx', 'Server_Maintenance.pdf',
        'Database_Schema.pdf', 'Backup_Schedule.xlsx', 'Security_Audit.pdf', 'Update_Instructions.pdf', 'System_Requirements.docx',
        
        // Miscellaneous Business Documents
        'Mission_Statement.pdf', 'Vision_Document.pdf', 'Company_Values.pdf', 'Strategic_Goals.docx', 'Business_Plan.pdf',
        'SWOT_Analysis.xlsx', 'Competitive_Intelligence.pdf', 'Customer_Testimonials.pdf', 'Case_Study.docx', 'White_Paper.pdf',
        'Research_Report.pdf', 'Survey_Results.xlsx', 'Feedback_Analysis.docx', 'Recommendation_Letter.pdf', 'Reference_Guide.pdf',
        
        // Additional Documents
        'Travel_Expense.xlsx', 'Reimbursement_Form.pdf', 'Time_Sheet.xlsx', 'Project_Status.docx', 'Weekly_Report.pdf',
        'Monthly_Summary.xlsx', 'Dashboard_Report.pdf', 'KPI_Metrics.xlsx', 'Goal_Tracking.xlsx', 'Action_Items.docx',
        'Follow_Up_Notes.docx', 'Client_Feedback.pdf', 'Service_Request.docx', 'Work_Order.pdf', 'Task_List.xlsx'
    ];
    
    const usernames = [
        // Pirate-themed usernames
        'blackbeard', 'ruby', 'jack', 'anne', 'longjohn', 'calico', 'oneeye',
        'sparrow', 'cutlass', 'hook', 'morgan', 'flint', 'silver', 'bones',
        'compass', 'cannon', 'galleon', 'kraken', 'treasure', 'parrot',
        'pegleg', 'rumrunner', 'seabiscuit', 'horizon', 'mack', 'seafox',
        'barnacle', 'corsair', 'madeye', 'sharktooth', 'sable', 'stormy',
        'ghost', 'reef', 'brine', 'captainmorgan', 'blacktail', 'redbeard',
        'ironhook', 'saltydog', 'pegasus', 'rumcutter', 'stormbreaker',
        'plankwalker', 'seadog', 'reefwalker', 'crowsnest', 'stormcloud',
        'harpoon', 'cutthroat', 'lagoon', 'captainsparrow'
    ];
    
    const sources = ['Windows PC', 'Mac', 'Mobile App', 'Web Portal', 'Email Print', 'Scan to Print'];
    const statuses = ['completed', 'printing', 'error', 'pending'];
    const statusWeights = [0.7, 0.1, 0.15, 0.05]; // Most jobs completed
    
    allJobs = [];
    
    // Generate 160 jobs to ensure at least 8 pages
    for (let i = 0; i < 160; i++) {
        const randomDoc = documentNames[Math.floor(Math.random() * documentNames.length)];
        const randomUser = usernames[Math.floor(Math.random() * usernames.length)];
        const randomSource = sources[Math.floor(Math.random() * sources.length)];
        const randomPages = Math.floor(Math.random() * 25) + 1; // 1-25 pages
        
        // Weighted random status selection
        let randomStatus;
        const rand = Math.random();
        if (rand < statusWeights[0]) randomStatus = statuses[0];
        else if (rand < statusWeights[0] + statusWeights[1]) randomStatus = statuses[1];
        else if (rand < statusWeights[0] + statusWeights[1] + statusWeights[2]) randomStatus = statuses[2];
        else randomStatus = statuses[3];
        
        // Generate realistic timestamps (last 30 days for more variety)
        const now = new Date();
        const daysAgo = Math.floor(Math.random() * 30);
        const hoursAgo = Math.floor(Math.random() * 24);
        const minutesAgo = Math.floor(Math.random() * 60);
        
        const jobTime = new Date(now.getTime() - (daysAgo * 24 * 60 * 60 * 1000) - (hoursAgo * 60 * 60 * 1000) - (minutesAgo * 60 * 1000));
        
        allJobs.push({
            id: String(2000 + i).padStart(4, '0'), // Start from 2000 to avoid conflicts
            document: randomDoc,
            user: randomUser,
            pages: randomPages,
            status: randomStatus,
            time: jobTime,
            source: randomSource
        });
    }
    
    // Sort by time (newest first)
    allJobs.sort((a, b) => b.time - a.time);
    filteredJobs = [...allJobs];
    
    updateJobsDisplay();
    updateJobStats();
}

// Update job statistics
function updateJobStats() {
    const today = new Date();
    const startOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    const startOfWeek = new Date(today.getTime() - (7 * 24 * 60 * 60 * 1000));
    
    const todayJobs = allJobs.filter(job => job.time >= startOfDay).length;
    const weekJobs = allJobs.filter(job => job.time >= startOfWeek).length;
    
    document.getElementById('total-jobs').textContent = allJobs.length;
    document.getElementById('today-jobs').textContent = todayJobs;
    document.getElementById('week-jobs').textContent = weekJobs;
}

// Display jobs in the table (updated to include clickable document links)
function updateJobsDisplay() {
    const tableBody = document.getElementById('jobs-table-body');
    const startIndex = (currentJobsPage - 1) * jobsPerPage;
    const endIndex = startIndex + jobsPerPage;
    const jobsToShow = filteredJobs.slice(startIndex, endIndex);
    
    tableBody.innerHTML = '';
    
    jobsToShow.forEach(job => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>#${job.id}</td>
            <td><a href="#" class="document-link" onclick="showDocumentModal('${job.document}'); return false;">${job.document}</a></td>
            <td>${job.user}</td>
            <td>${job.pages}</td>
            <td><span class="job-status ${job.status}">${job.status}</span></td>
            <td>${formatJobTime(job.time)}</td>
            <td>${job.source}</td>
        `;
        tableBody.appendChild(row);
    });
    
    updatePagination();
}

// Format job time for display
function formatJobTime(date) {
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);
    
    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
}

// Update pagination display
function updatePagination() {
    const totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
    document.getElementById('current-page').textContent = currentJobsPage;
    document.getElementById('total-pages').textContent = totalPages;
    
    document.getElementById('prev-btn').disabled = currentJobsPage === 1;
    document.getElementById('next-btn').disabled = currentJobsPage === totalPages;
}

// Filter jobs by status
function filterJobs(status) {
    if (status === 'all') {
        filteredJobs = [...allJobs];
    } else {
        filteredJobs = allJobs.filter(job => job.status === status);
    }
    
    currentJobsPage = 1;
    updateJobsDisplay();
    console.log(`Jobs filtered by status: ${status}, showing ${filteredJobs.length} jobs`);
}

// Pagination functions
function previousJobsPage() {
    if (currentJobsPage > 1) {
        currentJobsPage--;
        updateJobsDisplay();
    }
}

function nextJobsPage() {
    const totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
    if (currentJobsPage < totalPages) {
        currentJobsPage++;
        updateJobsDisplay();
    }
}

// Refresh jobs (simulate new jobs arriving)
function refreshJobs() {
    const newJobCount = Math.floor(Math.random() * 3) + 1;
    const documentNames = ['doc_a7f3k9.pdf', 'rep_x9w2e4.docx', 'pres_g4h7j2.pptx'];
    const usernames = ['john.smith', 'sarah.johnson', 'michael.brown'];
    
    for (let i = 0; i < newJobCount; i++) {
        const newJob = {
            id: String(1000 + allJobs.length + i).padStart(4, '0'),
            document: documentNames[i % documentNames.length],
            user: usernames[i % usernames.length],
            pages: Math.floor(Math.random() * 5) + 1,
            status: 'completed',
            time: new Date(),
            source: 'Windows PC'
        };
        
        allJobs.unshift(newJob); // Add to beginning
    }
    
    // Keep only last 50 jobs
    if (allJobs.length > 50) {
        allJobs = allJobs.slice(0, 50);
    }
    
    // Reapply current filter
    const currentFilter = document.getElementById('job-filter').value;
    filterJobs(currentFilter);
    updateJobStats();
    
    showSuccessModal(`Refreshed! ${newJobCount} new job(s) added.`);
}

// Clear job history
function clearJobHistory() {
    if (confirm('Are you sure you want to clear all job history? This action cannot be undone.')) {
        allJobs = [];
        filteredJobs = [];
        currentJobsPage = 1;
        updateJobsDisplay();
        updateJobStats();
        showSuccessModal('Job history cleared successfully.');
        console.log('Job history cleared by user');
    }
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Start status updates
    updatePrinterStatus();
    addFakeJobs();
    
    // Add some interactive elements
    document.addEventListener('keydown', function(e) {
        // Log keystrokes (for demonstration)
        if (e.target.type === 'password' || e.target.type === 'text') {
            console.log('Keystroke captured on:', e.target.id, 'Key:', e.key);
        }
    });
    
    // Detect copy/paste events
    document.addEventListener('paste', function(e) {
        console.log('Paste detected on field:', e.target.id);
    });
    
    // Log form field focus events
    document.addEventListener('focus', function(e) {
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') {
            console.log('Field focused:', e.target.id, 'Type:', e.target.type);
        }
    }, true);
    
    console.log('Fake Printer Interface Initialized');
    console.log('All form submissions are being captured and logged');
    
    // Initialize jobs data
    generateJobHistory();
    
    // Simulate periodic job updates
    setInterval(() => {
        // Occasionally add a new job automatically
        if (Math.random() < 0.3) { // 30% chance every interval
            const newJob = {
                id: String(1000 + allJobs.length).padStart(4, '0'),
                document: 'doc_auto.pdf',
                user: 'system.user',
                pages: Math.floor(Math.random() * 3) + 1,
                status: 'completed',
                time: new Date(),
                source: 'System'
            };
            
            allJobs.unshift(newJob);
            if (allJobs.length > 50) {
                allJobs = allJobs.slice(0, 50);
            }
            
            // Update display if showing all jobs
            const currentFilter = document.getElementById('job-filter').value;
            if (currentFilter === 'all') {
                filteredJobs = [...allJobs];
                updateJobsDisplay();
                updateJobStats();
            }
        }
    }, 25000); // Every 25 seconds
});

// Function to display captured data (updated to include unauthorized access attempts)
function showCapturedData() {
    const credentials = JSON.parse(localStorage.getItem('capturedCredentials') || '[]');
    const employees = JSON.parse(localStorage.getItem('employeeData') || '[]');
    const network = JSON.parse(localStorage.getItem('networkConfig') || '{}');
    const documentAccess = JSON.parse(localStorage.getItem('documentAccessAttempts') || '[]');
    const downloadAttempts = JSON.parse(localStorage.getItem('downloadAttempts') || '[]');
    const unauthorizedAccess = JSON.parse(localStorage.getItem('unauthorizedAccess') || '[]');
    
    console.log('=== CAPTURED DATA ===');
    console.log('Network Configurations:', network);
    console.log('Security Credentials:', credentials);
    console.log('Employee Data:', employees);
    console.log('Document Access Attempts:', documentAccess);
    console.log('Download Attempts:', downloadAttempts);
    console.log('Unauthorized Directory Access:', unauthorizedAccess);
    console.log('===================');
    
    return {
        networkConfig: network,
        credentials: credentials,
        employees: employees,
        documentAccessAttempts: documentAccess,
        downloadAttempts: downloadAttempts,
        unauthorizedAccess: unauthorizedAccess
    };
}

// Make function available globally for testing
window.showCapturedData = showCapturedData;