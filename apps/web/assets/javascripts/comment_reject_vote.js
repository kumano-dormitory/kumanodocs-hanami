function showRejectVote(voteDiv, voteAgree, voteDisagree, voteOnhold, rejectVoteDiv) {
  if (voteDiv) {
    voteDiv.style.display = 'none';
  }
  if (voteAgree) { voteAgree.setAttribute('disabled', true); voteAgree.removeAttribute('required'); }
  if (voteDisagree) { voteDisagree.setAttribute('disabled', true); voteDisagree.removeAttribute('required'); }
  if (voteOnhold) { voteOnhold.setAttribute('disabled', true); voteOnhold.removeAttribute('required'); }
  if (rejectVoteDiv) {
    rejectVoteDiv.style.display = 'grid';
  }
}

function showVote(voteDiv, voteAgree, voteDisagree, voteOnhold, rejectVoteDiv) {
  if (voteDiv) {
    voteDiv.style.display = 'grid';
  }
  if (voteAgree) { voteAgree.removeAttribute('disabled'); voteAgree.setAttribute('required', "required"); }
  if (voteDisagree) { voteDisagree.removeAttribute('disabled'); voteDisagree.setAttribute('required', "required"); }
  if (voteOnhold) { voteOnhold.removeAttribute('disabled'); voteOnhold.setAttribute('required', "required"); }
  if (rejectVoteDiv) {
    rejectVoteDiv.style.display = 'none';
  }
}

function toggleView(radioButton) {
  if (radioButton.checked) {
    let voteDivId = `article${radioButton.getAttribute('aria-controls')}-vote-div`;
    let voteAgreeId = `meeting-articles-${radioButton.getAttribute('aria-controls')}-vote_result-agree`;
    let voteDisagreeId = `meeting-articles-${radioButton.getAttribute('aria-controls')}-vote_result-disagree`;
    let voteOnholdId = `meeting-articles-${radioButton.getAttribute('aria-controls')}-vote_result-onhold`;
    let rejectVoteDivId = `article${radioButton.getAttribute('aria-controls')}-reject-vote-div`;
    let voteDiv = document.getElementById(voteDivId)
    let voteAgree = document.getElementById(voteAgreeId);
    let voteDisagree = document.getElementById(voteDisagreeId);
    let voteOnhold = document.getElementById(voteOnholdId);
    let rejectVoteDiv = document.getElementById(rejectVoteDivId);
    if (radioButton.value == "reject") {
      showRejectVote(voteDiv, voteAgree, voteDisagree, voteOnhold, rejectVoteDiv);
    } else {
      showVote(voteDiv, voteAgree, voteDisagree, voteOnhold, rejectVoteDiv);
    }
  }
}

function initializeRadioButton(radioButton) {
  toggleView(radioButton);
}

function setupRadioButton(radioButton) {
  initializeRadioButton(radioButton);

  radioButton.addEventListener('change', function (event) {
    toggleView(radioButton);
  });
}


function setupRadioButtons() {
  var radioButtons = [].slice.call(document.getElementsByClassName("p-radio__input"));

  radioButtons.forEach(setupRadioButton);
}

setupRadioButtons();