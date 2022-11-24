import axios from "axios";
export const TriggerBuild = (id, auth_token) => {
  const req = axios.post("/submitted_forms/build_survey", {dyna_form_id: id, authenticity_token: auth_token})
  req.then( resp => {
    if (resp.data.status === 204) {
      window.location =`/submitted_forms/${resp.data.submitted_form_id}`;
    } else {
      document.getElementById('watch-container').innerHTML = resp.data.msg;
    }
  });
}
